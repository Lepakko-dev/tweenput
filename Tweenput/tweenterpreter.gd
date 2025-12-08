@tool
extends Node
class_name Tweenterpreter
## Handles and run Tweenput code

var parser: TweenputParser;

var twc : TimeWindowController;
var processing_tw : bool = false;
var tw_start := 0;

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
	func clear():
		_labels.clear();
		_callables.clear();
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

# Var related to Non-active input waiting (for WINPUT instruction)
## Stores input actions that need to be listened on press.
var waiting_actions_press : Array[String];
## Stores input actions that need to be listened on release.
var waiting_actions_release : Array[String];
## Emitted when an input (this interpreter was waiting for) has been pressed or released.
signal input_found;

# Others
var current_tweens_waited : Dictionary[int,Tween];

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

func _unhandled_input(event: InputEvent) -> void:
	var i : int = 0;
	while i < waiting_actions_press.size():
		var action := waiting_actions_press[i];
		if event.is_action_pressed(action):
			waiting_actions_press.erase(action);
			input_found.emit();
		else:
			i += 1;
	i = 0;
	while i < waiting_actions_release.size():
		var action := waiting_actions_release[i];
		if event.is_action_released(action):
			waiting_actions_release.erase(action);
			input_found.emit();
		else:
			i += 1;


func _process(_delta:float) -> void:
	if processing_tw:
		if tw_start == 0: tw_start = Time.get_ticks_usec();
		var elapsed := float(Time.get_ticks_usec() - tw_start)/1000000.0;
		twc.check_input(elapsed);


func process_code(text:String) -> String:
	if not parser: 
		push_error("Tweenterpreter doesn't have a parser to process the given text.");
		return "";
		
	return parser.parse(text);

func run():
	if not parser: 
		push_error("Tweenterpreter doesn't have a parser to get the AST from.");
		return;
	
	print("--- Starting ---");
	for s in self_user_signals: remove_user_signal(s);
	self_user_signals.clear();
	
	set_tw_process(true);

	linked_signals.clear();
	id_pool.clear();
	for i in max_active_links:
		id_pool.append(i);
	
	ctx_list.resize(max_active_links+1);
	ctx_list.fill(Context.new());
	
	var node := parser.root_node;
	var ctx := ctx_list[max_active_links];
	while node: node = await _step(node,ctx);
	print("--- Stoping ---");
	
	# Warn all coroutines and wait them to finish their execution.
	for c in ctx_list:
		c.flags |= RUN_FLAG.ENDING;
	_cleaning_execution();
	while id_pool.size() < max_active_links:
		print("...")
		await coroutine_finished;
	set_tw_process(false);
	print("--- Finished ---");

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
	"QTE":QTE,
	"WQTE":WQTE,
	"ANIM":Callable(),
	"WANIM":Callable(),
	"STOP":STOP,
	"WINPUT":WINPUT,
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
				container = TweenputHelper.reflect(ref,cont_name).call();
			if not container:
				push_error("Tweenput: SET -> No container '%s' found for operator []."%cont_name);
				return;
			var method := TweenputHelper.reflect(container,"[]=");
			if method.is_valid():
				method.call(container,idx,value);
			else:
				push_error("Tweenput: SET -> Variable '%s' can't use the [] operator."%cont_name);
				return;
			var_name = cont_name+"[%s]"%idx;
	else: # No de-referencing
		if leaf is TweenputParser.LIdentifier:
			parser.variables.set(var_name,value);
		elif leaf is TweenputParser.LArrayAccess:
			var cont_name : String = leaf._node.node_name;
			var container : Variant = parser.variables.get(cont_name);
			var idx : Variant = leaf._idx.value();
			var method := TweenputHelper.reflect(container,"[]=");
			if method.is_valid():
				method.call(container,idx,value);
			else:
				push_error("Tweenput: SET -> Variable '%s' can't use the [] operator."%cont_name);
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
			current_tweens_waited[aux.tween.get_instance_id()] = aux.tween;
			await aux.tween.finished;
			current_tweens_waited.erase(aux.tween.get_instance_id());
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
			current_tweens_waited[tween.get_instance_id()] = tween;
			await tween.finished;
			current_tweens_waited.erase(tween.get_instance_id());
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
	elif node is TweenputParser.LVar: # Value could be Label(String) or Callable still
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
		var is_oneshot : bool = oneshot and (oneshot.value() as bool);
		if is_oneshot: sig_flags |= CONNECT_ONE_SHOT;
		var callable := _run_async.bind(lbl_val);
		var links : SignalLinkList = linked_signals.get_or_add(s.get_name(),SignalLinkList.new());
		links.add(lbl_val,callable);
		s.connect(_run_async.bind(lbl_val),sig_flags);
		print("LINK %s , %s, %s"%[s.get_name(),lbl_val,is_oneshot]);
	else:
		push_error("Tweenput: LINK -> 2º parameter must be String.");
		return;

func UNLINK(_ctx:Context, sig:TweenputParser.LangNode,label:TweenputParser.LangNode=null):
	var sig_val = sig.value();
	var s : Signal;
	if sig_val is String: # Internal signal
		s = _get_add_signal(sig_val);
	elif sig_val is Signal: # External signal
		s = sig_val;
	else:
		push_error("Tweenput: UNLINK -> 1º parameter must be Signal.");
		return;
	
	if label == null: # Disconnect ALL
		var s_name := s.get_name();
		var links : SignalLinkList = linked_signals.get(s_name,null);
		if links:
			for c in links._callables:
				if s.is_connected(c): 
					s.disconnect(c);
			links.clear();
		print("UNLINK %s"%s_name);
	else: # Disconnect the Callable of the given Label.
		var lbl_val = label.value();
		if lbl_val is not String:
			push_error("Tweenput: UNLINK -> 2º parameter must be String.");
			return;
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

func END(ctx:Context):
	ctx.flags |= RUN_FLAG.ENDING;
	print("END");
	return;


func QTE(center:TweenputParser.LangNode,radius:TweenputParser.LangNode,
		pre:TweenputParser.LangNode,post:TweenputParser.LangNode,
		valid:TweenputParser.LangNode,invalid:TweenputParser.LangNode,
		channel:TweenputParser.LangNode):
	if not center or not radius or not pre or not post or not valid or not invalid or not channel:
		push_error("Tweenput: QTE -> Undefined variables.");
		return;
	
	var v = valid.value();
	if v is not Array:
		push_error("Tweenput: QTE -> Parameter of accepted input must be an array.");
		return;
	var accepted : Array[String];
	for action in v:
		if action is String:
			accepted.append(action as String);
		else:
			push_error("Tweenput: QTE -> Arrays must contain Strings only.");
			return;
	
	var iv = invalid.value();
	if iv is not Array:
		push_error("Tweenput: QTE -> Parameter of rejected input must be an array.");
		return;
	var rejected : Array[String];
	for action in iv:
		if action is String:
			rejected.append(action as String);
		else:
			push_error("Tweenput: QTE -> Arrays must contain Strings only.");
			return;
	
	var c := center.value() as float;
	var r := radius.value() as float;
	var la := pre.value() as float;
	var ra := post.value() as float;
	var ch := channel.value() as int;
	var tw := TimeWindow.new(c,r,la,ra,accepted,rejected);
	twc.add_tw(tw,ch);
	print("QTE %4.2f %4.2f %4.2f %4.2f %s %s %d"%[c,r,la,ra,accepted,rejected,ch]);

func WQTE(channel:TweenputParser.LangNode):
	if not channel: 
		push_error("Tweenput: WQTE -> No channel selected for wait.");
		return;
	var channel_id = channel.value() as int;
	if channel_id is not int:
		push_error("Tweenput: WQTE -> Channel index must be an integer.");
		return;
	
	var tw_channel := twc.get_channel(channel_id);
	await tw_channel.processed;
	var result := tw_channel.get_last_processed_value();
	if result == TimeWindow.RESULT.IGNORED:
		push_warning("Tweenput: WQTE -> Retrieved unexpected value.");

	var res_dict : Dictionary = parser.variables.get_or_add("res_qte",{});
	res_dict[channel_id]=result;
	print("WQTE %d (%s)"%[channel_id,TimeWindow.RESULT.find_key(result)]);


func STOP(node_t:TweenputParser.LangNode):
	if not node_t:
		push_error("Tweenput: STOP -> Undefined variables.");
		return;
	var tween = node_t.value();
	if tween is not Tween:
		push_error("Tweenput: STOP -> Parameter must be a tween.");
		return;
	var t:= (tween as Tween)
	t.stop();
	t.finished.emit();
	print("STOP %s"%node_t.node_name);

func WINPUT(_ctx:Context, input:TweenputParser.LangNode, release:TweenputParser.LangNode=null):
	if not input:
		push_error("Tweenput: WINPUT -> Undefined variable.");
		return;
	var input_action = input.value();
	if input_action is not String:
		push_error("Tweenput: WINPUT -> First parameter must be a String.");
		return;
	if not InputMap.has_action(input_action):
		push_error("Tweenput: WINPUT -> Action '%s' is not registered in the InputMap."%input_action);
		return;
	
	var is_release : bool = release and release.value();
	if is_release:
		if not waiting_actions_release.has(input_action):
			waiting_actions_release.append(input_action);
	else:
		if not waiting_actions_press.has(input_action):
			waiting_actions_press.append(input_action);
	
	var wait : bool = true; 
	while wait:
		await input_found;
		if is_release:
			if input_action not in waiting_actions_release:
				wait = false;
		else:
			if input_action not in waiting_actions_press:
				wait = false;
	print("WINPUT %s %s"%[input_action,is_release]);

#endregion

func _cleaning_execution():
	# Uncloging signal dependent waiting instructions
	# WINPUT
	waiting_actions_release.clear();
	waiting_actions_press.clear();
	input_found.emit();
	# WQTE
	for c in twc._channels:
		twc.get_channel(c).processed.emit();
	# WAIT (internal signals only)
	for sig in self_user_signals.values():
		(sig as Signal).emit();
	# WAIT (any awaited Tween)
	for val in current_tweens_waited.values():
		var t := val as Tween;
		t.stop();
		t.finished.emit();

func _get_add_signal(sig_name:String) -> Signal:
	var s : Signal;
	if not self.has_user_signal(sig_name):
		self.add_user_signal(sig_name);
		s = Signal(self, sig_name);
		self_user_signals[sig_name] = s;
	else:
		s = self_user_signals[sig_name];
	return s;

func set_tw_process(val:bool):
	processing_tw = val;
	if val:
		twc.clear_channels();
		tw_start = 0;

func get_id_from_pool() -> int:
	if id_pool.size() == 0: return -1;
	return id_pool.pop_back();
func release_id_to_pool(id:int) -> void:
	if id in id_pool: return;
	id_pool.append(id);
	#print("New size: ",id_pool.size());
