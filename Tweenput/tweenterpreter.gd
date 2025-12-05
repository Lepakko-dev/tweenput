@tool
extends Node
class_name Tweenterpreter
## Handles and run Tweenput code

var parser: TweenputParser;
var twc : TimeWindowController;

## Flags to control the flow of execution of the interpreter
enum RUN_FLAG {JUMPING=1, CALLING=2, ENDING=4};


## Data relative to the execution of the interpreter
class Context:
	var flags : int = 0;
	var jmp_target:TweenputParser.LInstr;
	var call_stack : Array[TweenputParser.LInstr];
	func reset() -> void:
		flags = 0;
		jmp_target = null;
		call_stack.clear();

# Coroutine implementation variables
## List of context per coroutine.
var ctx_list : Array[Context];

## Map of dynamic internal signals created during execution
var self_user_signals : Dictionary[String,Signal];
## A pair of lists of coroutines and the label they should start from.
class SignalLinkList:
	var _labels : PackedStringArray;
	var _callables : Array[Callable];
	func add(label:String,callable:Callable):
		_labels.append(label);
		_callables.append(callable);
	func remove(label:String):
		var idx := _labels.find(label);
		_labels.remove_at(idx);
		_callables.remove_at(idx);
	func get_callable(label:String) -> Callable:
		var idx := _labels.find(label);
		if idx < 0: return Callable();
		return _callables[idx];
## Map of signals linked to coroutine executions
var linked_signals : Dictionary[String,SignalLinkList]; # Key is signal name
## Pool for id generation for coroutines
var id_pool : Array[int] = [];
## Max number of coroutines being executed at a time (excluding the main interpreter)
var max_active_links := 16;
signal coroutine_finished;

func _init() -> void:
	twc = TimeWindowController.new();
func _ready() -> void:
	for child in get_children():
		if child is TweenputParser:
			parser = child;
			break;
	if parser: parser.instructions = instructions;

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = [];
	var _has_parser : bool = false;
	for child in get_children():
		if child is TweenputParser:
			_has_parser = true;
			break;
	if not _has_parser: warnings.append("Tweenterpreter must have a TweenputParser node as a child");
	return warnings;

func process_code(text:String) -> String:
	if not parser: 
		push_error("Tweenterpreter doesn't have a parser to process the given text.");
		return "";
		
	return parser.parse(text);

func run():
	if not parser: 
		push_error("Tweenterpreter doesn't have a parser to get the AST from.");
		return;
	
	for s in self_user_signals: remove_user_signal(s);
	self_user_signals.clear();
	
	linked_signals.clear();
	id_pool.clear();
	for i in max_active_links:
		id_pool.append(i);
	
	ctx_list.resize(max_active_links+1);
	ctx_list.fill(Context.new());
	
	var node := parser.root_node;
	var ctx := ctx_list[max_active_links];
	while node: node = await _step(node,ctx);
	while id_pool.size() < max_active_links:
		print("...")
		await coroutine_finished;

## Starts the concurrent execution of the Tweenput code from a specific label.
func _run_async(label:String):
	var id := get_id_from_pool();
	if id < 0:
		push_warning("Tweenput: Reached maximum coroutine count.  Ignoring execution from '%s'."%label);
		return;
	if label not in parser.label_map:
		push_error("Tweenput: Couldn't start the execution of a coroutine. Label name not found (%s)"%label);
		return;
	
	var node : TweenputParser.LInstr = parser.label_map.get(label);
	var ctx := ctx_list[id];
	ctx.reset();
	#print("Starting execution of coroutine from label '%s', with id %d"%[label,id]);
	while node: node = await _step(node,ctx);
	#print("Finished coroutine execution (%d)"%id);
	release_id_to_pool(id);
	coroutine_finished.emit();
	return;

func _step(node:TweenputParser.LInstr, ctx:Context) -> TweenputParser.LInstr:
	@warning_ignore("redundant_await")
	var instr := node.execute();
	if instr.get_argument_count() > 0: # Instruction needs ctx
		# (that or has optional parameters, in which case, the instruction 
		# must accept the ctx as its first parameter).
		await instr.call(ctx);
	else:
		await instr.call();
	var next_node : TweenputParser.LInstr = node.next;
	if ctx.flags & RUN_FLAG.JUMPING:
		next_node = ctx.jmp_target;
		ctx.jmp_target = null;
	if ctx.flags & RUN_FLAG.CALLING:
		ctx.call_stack.append(node.next);
	if ctx.flags & RUN_FLAG.ENDING:
		next_node = null;
	ctx.flags = 0;
	return next_node;

#region Instructions
var instructions : Dictionary[String,Callable] = {
	"SET":SET,
	"SWAP":SWAP,
	# Flow of Execution Related
	"EMIT":EMIT,
	"WAIT":WAIT,
	"JMP":JMP,
	"CALL":CALL,
	"RET":RET,
	"LINK":LINK,
	"UNLINK":UNLINK,
	"END":END,
	# Other Animation Related
	"QTE":Callable(),
	"WQTE":Callable(),
	"ANIMATE":Callable(),
	"WANIMATE":Callable(),
};

func SET(id:TweenputParser.LangNode,expr:TweenputParser.LangNode):
	if id is not TweenputParser.LVar: 
		push_error("Tweenput: SET -> 1º param not a variable");
		return;
	
	var var_name : String = id.node_name;
	var value = expr.value();
	
	# Finding leaf node
	var leaf := id;
	var must_dereference := false;
	if leaf is TweenputParser.LDeReference:
		leaf = leaf.b;
		must_dereference = true;
	elif leaf is TweenputParser.LBinOp:
		push_error("Tweenput: SET -> Cannot assign a value to a volatile expression.");
		return;
	if leaf is TweenputParser.LMethodCall:
		push_error("Tweenput: SET -> Cannot assign a value to a method call.");
		return;
	

	if must_dereference:
		id.value(); # Force update value of variable 'ref_ctx'
		var ref : Variant = (leaf as TweenputParser.LVar).ref_ctx;
		if leaf is TweenputParser.LIdentifier:
			ref.set(leaf.node_name,value);
		elif leaf is TweenputParser.LArrayAccess:
			var cont_name : String = leaf._node.node_name;
			var container : Variant;
			var idx : Variant = leaf._idx.value();
			if ref is Object:
				if leaf._node is TweenputParser.LIdentifier:
					container = ref.get(cont_name);
			else: # Need to manually reflect
				container = TweenputInstructions.reflect(ref,cont_name).call();
			if not container:
				push_error("Couldn't retrieve container '%s' for operator []."%cont_name);
				return;
			var method := TweenputInstructions.reflect(container,"[]=");
			if method.is_valid():
				method.call(container,idx,value);
			else:
				push_error("Variable '%s' can't use the [] operator."%cont_name);
				return;
			var_name = cont_name+"[%s]"%idx;
	else: # No de-referencing
		if leaf is TweenputParser.LIdentifier:
			parser.variables.set(leaf.node_name,value);
		elif leaf is TweenputParser.LArrayAccess:
			var cont_name : String = leaf._node.node_name;
			var container : Variant = parser.variables.get(cont_name);
			var idx : Variant = leaf._idx.value();
			var method := TweenputInstructions.reflect(container,"[]=");
			if method.is_valid():
				method.call(container,idx,value);
			else:
				push_error("Variable '%s' can't use the [] operator."%cont_name);
				return;
			var_name = cont_name+"[%s]"%idx;

	print("SET %s , %s"%[var_name,value]);

func SWAP(a:TweenputParser.LangNode,b:TweenputParser.LangNode):
	if a is not TweenputParser.LIdentifier:
		push_error("Tweenput: SWAP -> 1º param not a variable");
		return;
	if b is not TweenputParser.LIdentifier:
		push_error("Tweenput: SWAP -> 2º param not a variable");
		return;
	
	var a_name : String = a.node_name;
	var b_name : String = b.node_name;
	if a_name not in parser.variables or b_name not in parser.variables:
		push_error("Tweenput: SWAP -> Undefined variables.");
		return;
	
	var aux = parser.variables.get(a_name);
	parser.variables[a_name] = parser.variables.get(b_name);
	parser.variables[b_name] = aux;
	print("SWAP %s , %s"%[a_name,b_name]);

func EMIT(sig_node:TweenputParser.LangNode):
	if sig_node is TweenputParser.LString: # Internal Signal
		var sig_name : String = sig_node.value();
		if sig_name.is_empty(): return;
		_get_add_signal(sig_name).emit();
		print("EMIT %s"%sig_name);
	elif sig_node is TweenputParser.LVar: # External Signal
		var sig_obj : Signal = sig_node.value();
		if sig_obj.is_null(): return;
		sig_obj.emit();
		print("EMIT %s"%sig_obj.get_name());
	else:
		push_error("Tweenput: EMIT -> Wrong argument type. Must be a string or a variable.")
	return;

func WAIT(node:TweenputParser.LangNode):
	if node is TweenputParser.LString: # Internal Signals or Tween calls
		var val : String = node.value() as String;
		var is_sig : bool = val in self_user_signals;
		var is_tween : bool = val in parser._tween_map;
		if is_sig and is_tween:
			push_error("Tweenput: WAIT -> Found ambiguity (%s). There is a signal and a tween with the same name."%val);
			return;
		if is_sig:
			await self_user_signals[val];
			print("WAIT %s"%val);
		elif is_tween:
			var aux := TweenputParser.LTweenExe.new(val,parser);
			aux.execute().call();
			await aux.tween.finished;
			print("WAIT %s"%val);
		else:
			push_error("Tweenput: WAIT -> No internal signal or tween found with name %s."%val);
	elif node is TweenputParser.LVar: # IDs, member access and method calls
		var val = node.value();
		if val is Callable:
			var callable := val as Callable;
			await callable.call();
			print("WAIT %s"%callable.get_method());
			return;
		if val is Signal:
			var sig := val as Signal;
			await sig;
			print("WAIT %s"%sig.get_name());
			return;
		if val is Tween:
			var tween := val as Tween;
			if not tween.is_valid():
				push_error("Tweenput: WAIT -> Invalid external Tween, it probably has already finished. Godot doesn't allow reusing tweens.")
				return;
			if tween.get_loops_left() == -1:
				push_error("Tweenput: WAIT -> Tried waiting for an infinitely looping Tween.");
				return;
			if not tween.is_running(): tween.play();
			await tween.finished;
			print("WAIT %s"%node.node_name);
			return;
		elif val is float:
			await get_tree().create_timer(val).timeout
			print("WAIT %s sec"%val);
			return;
		else:
			push_error("Tweenput: WAIT -> Parameter is not of type Callable or Signal.");
			return;
	elif node is TweenputParser.LConst:
		var val = node.value();
		await get_tree().create_timer(val).timeout
		print("WAIT %s sec"%val);
		return;

func JMP(ctx:Context,label:TweenputParser.LangNode,condition:TweenputParser.LangNode):
	if not label or not condition:
		push_error("Tweenput: JMP -> Undefined variables.");
		return;
	
	var label_val = label.value();
	if label_val is not String:
		push_error("Tweenput: JMP -> 1º argument is not a String (%s)."%label_val);
		return;
	
	var cond_val = condition.value();
	if cond_val:
		ctx.jmp_target = parser.label_map.get(label_val);
		if not ctx.jmp_target:
			push_error("Tweenput: JMP -> Label '%s' unknown."%label_val);
			return;
		ctx.flags |= RUN_FLAG.JUMPING;
	print("JMP %s , %s"%[label_val,cond_val as bool]);

func CALL(ctx:Context,node:TweenputParser.LangNode):
	var val = node.value();
	if node is TweenputParser.LString: # Must be label
		ctx.jmp_target = parser.label_map.get(val);
		if ctx.jmp_target: 
			ctx.flags |= RUN_FLAG.JUMPING | RUN_FLAG.CALLING;
		else:
			push_error("Tweenput: CALL -> Label '%s' unknown."%val);
			return;
	elif node is TweenputParser.LVar: # Value could be String or Callable still
		if val is Callable:
			val.call(); # Unawaited counterpart of 'WAIT <Callable>' instruction
		elif val is String:
			ctx.jmp_target = parser.label_map.get(val);
			if ctx.jmp_target: 
				ctx.flags |= RUN_FLAG.JUMPING | RUN_FLAG.CALLING;
			else: 
				push_error("Tweenput: CALL -> Label '%s' unknown."%val);
				return;
		else:
			push_error("Tweenput: CALL -> Parameter must result in a String or Callable.")
			return;
	else:
		push_error("Tweenput: CALL -> Only String and Callable are allowed.")
		return;
	print("CALL %s"%val);

func RET(ctx:Context):
	var node = ctx.call_stack.pop_back();
	if node: 
		ctx.jmp_target = node;
		ctx.flags |= RUN_FLAG.JUMPING;
	else:
		push_error("Tweenput: RET -> Call stack is empty, cannot return. Ending routine.");
		ctx.flags |= RUN_FLAG.ENDING;
		return;
	print("RET");

func LINK(_ctx:Context,sig:TweenputParser.LangNode,label:TweenputParser.LangNode,oneshot:TweenputParser.LangNode = null):
	# Must have ctx as 1º param because there is an optional parameter (oneshot)
	var sig_val = sig.value();
	var s : Signal;
	if sig_val is String: # Internal signal
		s = _get_add_signal(sig_val);
	elif sig_val is Signal: # External signal
		s = sig_val;
	else:
		push_error("Tweenput: LINK -> 1º parameter must be Signal.");
		return;
	
	var lbl_val = label.value();
	if lbl_val is String:
		var sig_flags : int = CONNECT_REFERENCE_COUNTED;
		var is_oneshot : bool = oneshot and oneshot.value() == true;
		if is_oneshot: sig_flags |= CONNECT_ONE_SHOT;
		var callable := _run_async.bind(lbl_val);
		var links : SignalLinkList = linked_signals.get_or_add(s.get_name(),SignalLinkList.new());
		links.add(lbl_val,callable);
		s.connect(_run_async.bind(lbl_val),sig_flags);
		print("LINK %s , %s, %s"%[s.get_name(),lbl_val,is_oneshot]);
	else:
		push_error("Tweenput: LINK -> 2º parameter must be String.");
		return;

func UNLINK(sig:TweenputParser.LangNode,label:TweenputParser.LangNode):
	var sig_val = sig.value();
	var s : Signal;
	if sig_val is String: # Internal signal
		s = _get_add_signal(sig_val);
	elif sig_val is Signal: # External signal
		s = sig_val;
	else:
		push_error("Tweenput: UNLINK -> 1º parameter must be Signal.");
		return;
	
	var lbl_val = label.value();
	if lbl_val is String:
		var s_name := s.get_name();
		var links : SignalLinkList = linked_signals.get(s_name,null);
		if links:
			var c := links.get_callable(lbl_val);
			if not c.is_valid():
				push_error("Tweenput: UNLINK -> Label '%s' is not connected to %s"%[lbl_val,s_name]);
				return;
			s.disconnect(c);
			links.remove(lbl_val);
		print("UNLINK %s , %s"%[s_name,lbl_val]);
	else:
		push_error("Tweenput: UNLINK -> 2º parameter must be String.");
		return;

func END(ctx:Context):
	ctx.flags |= RUN_FLAG.ENDING;
	print("END");
	return;


func QTE(_center:TweenputParser.LangNode,_radius:TweenputParser.LangNode,
		_pre:TweenputParser.LangNode,_post:TweenputParser.LangNode,
		_valid:TweenputParser.LangNode=null,_invalid:TweenputParser.LangNode=null,
		_channel:TweenputParser.LangNode=null):
	pass

#endregion

func _get_add_signal(sig_name:String) -> Signal:
	var s : Signal;
	if not self.has_user_signal(sig_name):
		self.add_user_signal(sig_name);
		s = Signal(self, sig_name);
		self_user_signals[sig_name] = s;
	else:
		s = self_user_signals[sig_name];
	return s;

func get_id_from_pool() -> int:
	if id_pool.size() == 0: return -1;
	return id_pool.pop_back();
func release_id_to_pool(id:int) -> void:
	if id in id_pool: return;
	id_pool.append(id);
	#print("New size: ",id_pool.size());
