@tool
extends Node
class_name Tweenterpreter
## Handles and run Tweenput code.


#region Tweenput execution related
@export var debug: bool:
	set(value):
		debug = value;
		if logger:
			logger.enable(value);
var logger: TweenputLogger;

## Parser needed to process tweenput code into an AST (Abstract Syntax Tree)
var parser: TweenputParser;

## Flags to control the interpreter's flow of execution.
enum RUN_FLAG {
	## Jump to another instruction.
	JUMPING = 1,
	## Uses the call stack.
	CALLING = 2,
	## End execution.
	ENDING = 4};

## Execution-time data related to the flow of the interpreter
class Context:
	## Set of [enum Tweenterpreter.RUN_FLAG] flags.
	var flags: int = 0;
	## The instruction node where the interpreter should jump if any related flag is active.
	var jmp_target: TweenputParser.LInstr;
	## Stack of instructions to return to when a sub-routine ends.
	var call_stack: Array[TweenputParser.LInstr];
	func reset() -> void:
		flags = 0;
		jmp_target = null;
		call_stack.clear();

#endregion

#region QTE managing variables
## Controller for QTEs used during code execution.
var twc: TimeWindowController;

## Indicates whether the [TimeWindowController] is active.
var _processing_tw: bool;

## Relative timestamp for the 0 seconds mark of the [TimeWindowController].
var _tw_start: int;

#endregion

#region Coroutine managing related
## Max number of active coroutines at a time (excluding the main routine).
@export var max_active_coroutines: int = 16;

## List of context per coroutine.
var _ctx_list: Array[Context];

## Map of disposable signals created during execution
var _internal_signals: Dictionary[String, Signal];

## Maps code labels to coroutines ([Callable]) connected to a signal.
class CoroutineLinks:
	# This class exists solely because nested typed containers are not supported.
	var _dict: Dictionary[String, Callable];
	
	func add(label: String, callable: Callable):
		_dict[label] = callable;
	
	func remove(label: String):
		_dict.erase(label);
	
	func clear():
		_dict.clear();
	
	func get_callable(label: String) -> Callable:
		return _dict.get(label, Callable());

## Maps name of signal being listened for coroutine executions.
var _linked_coroutines: Dictionary[String, CoroutineLinks];

## Pool of free coroutine IDs.
var _id_pool: Array[int];

## Emitted when a coroutine has finished its execution
## (used by the main routine to avoid dangling coroutines)
signal _coroutine_finished;

#endregion

#region Tweens and Input waiting variables
## Maps the instance id of each tween being waited.
var _current_tweens_waited: Dictionary[int, Tween];

## Stores input actions that need to be listened on press.
var _waiting_actions_press: Array[String];

## Stores input actions that need to be listened on release.
var _waiting_actions_release: Array[String];

## Emitted when an input (this interpreter is waiting for) has been pressed or released.
signal _input_found;

#endregion


## Updates the AST of the interpreter with the new code.[br][br]
## [b]Note:[/b] Must be called at least once before running this interpreter.
func process_code(code: String) -> String:
	if not parser:
		logger.err("Tweenterpreter doesn't have a parser to process the given text.");
		return "";
	return parser.parse(code);


## Starts the execution of the tweenput code.[br][br]
## [b]Note:[/b] This is a coroutine, can be awaited.
func run():
	if not parser:
		logger.err("Tweenterpreter doesn't have a parser to get the AST from.");
		return ;
	
	logger.p_log("--- Starting ---");
	for s in _internal_signals: remove_user_signal(s);
	_internal_signals.clear();
	
	_set_tw_process(true);

	_linked_coroutines.clear();
	_id_pool.clear();
	for i in max_active_coroutines:
		_id_pool.append(i);
	
	_ctx_list.resize(max_active_coroutines + 1);
	_ctx_list.fill(Context.new());
	
	var node := parser.root_node;
	var ctx := _ctx_list[max_active_coroutines];
	while node: node = await _step(node, ctx);
	logger.p_log("--- Stoping ---");
	
	# Warn all coroutines and wait them to finish their execution.
	for c in _ctx_list:
		c.flags |= RUN_FLAG.ENDING;
	_cleaning_execution();
	while _id_pool.size() < max_active_coroutines:
		logger.p_log("...")
		await _coroutine_finished;
	_set_tw_process(false);
	logger.p_log("--- Finished ---");
	return ;


func set_variable(var_name:String,value:Variant)->void:
	parser.variables[var_name] = value;


func _init() -> void:
	twc = TimeWindowController.new();
	logger = TweenputLogger.new();
	logger.enable(debug);

func _ready() -> void:
	for child in get_children():
		if child is TweenputParser:
			parser = child;
			break ;
	if parser: parser.instructions = instructions;

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = [];
	var _has_parser: bool = false;
	for child in get_children():
		if child is TweenputParser:
			_has_parser = true;
			break ;
	if not _has_parser:
		warnings.append("Tweenterpreter must have a TweenputParser node as a child");
	return warnings;


func _unhandled_input(event: InputEvent) -> void:
	# For the WINPUT instruction
	var i: int = 0;
	while i < _waiting_actions_press.size():
		var action := _waiting_actions_press[i];
		if event.is_action_pressed(action):
			_waiting_actions_press.erase(action);
			_input_found.emit();
		else:
			i += 1;
	i = 0;
	while i < _waiting_actions_release.size():
		var action := _waiting_actions_release[i];
		if event.is_action_released(action):
			_waiting_actions_release.erase(action);
			_input_found.emit();
		else:
			i += 1;

func _process(_delta: float) -> void:
	if _processing_tw:
		if _tw_start == 0: _tw_start = Time.get_ticks_usec();
		var elapsed := float(Time.get_ticks_usec() - _tw_start) / 1000000.0;
		twc.check_input(elapsed);


## Coroutine that executes Tweenput code from a specific label.
func _run_async(label: String):
	var id := _get_id_from_pool();
	if id < 0:
		logger.warn("""Tweenput: Reached maximum coroutine count. 
			Ignoring execution from '%s'."""%label);
		return ;
	if label not in parser.label_map:
		_release_id_to_pool(id);
		logger.err("""Tweenput: Couldn't start the execution of a coroutine. 
			Label name not found (%s)"""%label);
		return ;
	
	var node: TweenputParser.LInstr = parser.label_map.get(label);
	var ctx := _ctx_list[id];
	ctx.reset();
	#logger.p_log("Starting execution of coroutine from label '%s', with id %d"%[label,id]);
	while node: node = await _step(node, ctx);
	_release_id_to_pool(id);
	return ;

## Executes a single instruction node and handle any set execution flags.
func _step(node: TweenputParser.LInstr, ctx: Context) -> TweenputParser.LInstr:
	var instr := node.execute();
	if instr.get_argument_count() > 0: # Instruction needs ctx
		# (that or has optional parameters, in which case, the instruction 
		# must accept the ctx as its first parameter).
		await instr.call(ctx);
	else:
		await instr.call();
	var next_node: TweenputParser.LInstr = node.next;
	# Consumes flags in order of priority
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
## Implementation of the instruction set allowed in the Tweenput code.
var instructions: Dictionary[String, Callable] = {
	"SET": __set,
	"SWAP": __swap,
	# Flow of Execution Related
	"EMIT": __emit,
	"WAIT": __wait,
	"JMP": __jmp,
	"CALL": __call,
	"RET": __ret,
	"LINK": __link,
	"UNLINK": __unlink,
	"END": __end,
	# Other Animation Related
	"QTE": __qte,
	"WQTE": __wqte,
	"STOP": __stop,
	"WINPUT": __winput,
};

## Assign a new value to the specified variable (an array element can be assigned too).[br][br]
## - [param id]: Node representing the variable to be assigned to.[br]
## - [param expr]: Any expression that results into any [Variant] value.
## [codeblock]
## SET var1, 1;				# OK
## SET var1, var2;			# OK
## SET array[0], var1;		# OK
## SET array[idx], var1; 	# OK
## SET var1.member, var2;	# OK
## SET var1, var2 + 10;		# OK
##
## SET 1, variable;			# ERROR
## SET var1.method(), var2;	# ERROR
## SET var1 + 10, var2;		# ERROR
## [/codeblock]
func __set(id: TweenputParser.LangNode, expr: TweenputParser.LangNode):
	if id is not TweenputParser.LVar:
		logger.err("Tweenput: SET -> 1º param not a variable");
		return ;
	
	var var_name: String = id.node_name;
	var value = expr.value();
	
	# Finding leaf node
	var leaf := id;
	var must_dereference := false;
	if leaf is TweenputParser.LDeReference:
		leaf = leaf.b;
		must_dereference = true;
	elif leaf is TweenputParser.LBinOp:
		logger.err("Tweenput: SET -> Cannot assign a value to a volatile expression.");
		return ;
	if leaf is TweenputParser.LMethodCall:
		logger.err("Tweenput: SET -> Cannot assign a value to a method call.");
		return ;
	
	if must_dereference:
		id.value(); # Force update value of variable 'ref_ctx'
		var ref: Variant = (leaf as TweenputParser.LVar).ref_ctx;
		if leaf is TweenputParser.LIdentifier:
			ref.set(leaf.node_name, value);
		elif leaf is TweenputParser.LArrayAccess:
			var cont_name: String = leaf._node.node_name;
			var container: Variant;
			var idx: Variant = leaf._idx.value();
			if ref is Object:
				if leaf._node is TweenputParser.LIdentifier:
					container = ref.get(cont_name);
			else: # Need to manually reflect
				container = TweenputHelper.reflect(ref, cont_name).call();
			if not container:
				logger.err("Tweenput: SET -> No container '%s' found for operator []."%cont_name);
				return ;
			var method := TweenputHelper.reflect(container, "[]=");
			if method.is_valid():
				method.call(container, idx, value);
			else:
				logger.err("Tweenput: SET -> Variable '%s' can't use the [] operator."%cont_name);
				return ;
			var_name = cont_name + "[%s]"%idx;
	else: # No de-referencing
		if leaf is TweenputParser.LIdentifier:
			parser.variables.set(var_name, value);
		elif leaf is TweenputParser.LArrayAccess:
			var cont_name: String = leaf._node.node_name;
			var container: Variant = parser.variables.get(cont_name);
			var idx: Variant = leaf._idx.value();
			var method := TweenputHelper.reflect(container, "[]=");
			if method.is_valid():
				method.call(container, idx, value);
			else:
				logger.err("Tweenput: SET -> Variable '%s' can't use the [] operator."%cont_name);
				return ;
			var_name = cont_name + "[%s]"%idx;

	logger.p_log("SET %s , %s" % [var_name, value]);

## Swap the contents of any pair of variables.[br][br]
## - [param a]: Node representing a variable.[br]
## - [param b]: Node representing a variable.[br][br]
## [b]Note:[/b] Won't swap members.
## [codeblock]
## SWAP var1, var2 			# OK
##
## SWAP var1.member, var2 	# ERROR
## SWAP var1, "string" 		# ERROR
## [/codeblock]
func __swap(a: TweenputParser.LangNode, b: TweenputParser.LangNode):
	if a is not TweenputParser.LIdentifier:
		logger.err("Tweenput: SWAP -> 1º param not a variable");
		return ;
	if b is not TweenputParser.LIdentifier:
		logger.err("Tweenput: SWAP -> 2º param not a variable");
		return ;
	
	var a_name: String = a.node_name;
	var b_name: String = b.node_name;
	if a_name not in parser.variables or b_name not in parser.variables:
		logger.err("Tweenput: SWAP -> Undefined variables.");
		return ;
	
	var aux = parser.variables.get(a_name);
	parser.variables[a_name] = parser.variables.get(b_name);
	parser.variables[b_name] = aux;
	logger.p_log("SWAP %s , %s" % [a_name, b_name]);

## Emits the given signal (both internal or external).[br][br]
## - [param sig_node] Node whose value must be a [Signal] or a [String].[br]
## [codeblock]
## EMIT "internal_sig"  		# OK
##
## SET variable, "i_sig"
## EMIT variable				# OK
##
## EMIT external_signal 		# OK if the variant is of type Signal.
##
## SET variable, 10
## EMIT variable		 		# ERROR
## [/codeblock]
func __emit(sig_node: TweenputParser.LangNode):
	if sig_node is TweenputParser.LString: # Internal Signal
		var sig_name: String = sig_node.value();
		if sig_name.is_empty(): return ;
		_get_add_signal(sig_name).emit();
		logger.p_log("EMIT %s"%sig_name);
	elif sig_node is TweenputParser.LVar: # External Signal
		var sig_obj: Signal = sig_node.value();
		if sig_obj.is_null(): return ;
		sig_obj.emit();
		logger.p_log("EMIT %s"%sig_obj.get_name());
	else:
		logger.err("Tweenput: EMIT -> Wrong argument type. Must be a string or a variable.");
	return ;

## Pauses the current routine depending on the type of the [param node]'s value:[br]
## - If [String]: If it's a [Signal] waits it, if it's a [Tween] play & waits it.[br]
## - If [Callable]: Waits until the callable finishes its execution.[br]
## - If [Signal]: Waits until the signal is emitted.[br]
## - If [Tween]: Plays the tween and waits for it to finish (Skips if invalid).[br]
## - If [float]: Waits the ammount of time in seconds.
## [codeblock]
## WAIT 1.0 				# OK
## WAIT 1					# OK (Implicit conversion)
## WAIT "signal"			# OK
## WAIT "tween" 			# OK (will rebuild the tween)
## WAIT tween				# OK
## WAIT object.method		# OK
## WAIT object.signal		# OK
## [/codeblock]
func __wait(node: TweenputParser.LangNode):
	if node is TweenputParser.LString: # Internal Signals or Tween calls
		var val: String = node.value() as String;
		var is_sig: bool = val in _internal_signals;
		var is_tween: bool = val in parser._tween_map;
		if is_sig and is_tween:
			logger.err("""Tweenput: WAIT -> Found ambiguity (%s). 
				There is a signal and a tween with the same name."""%val);
			return ;
		if is_sig:
			await _internal_signals[val];
			logger.p_log("WAIT %s"%val);
		elif is_tween:
			var aux := TweenputParser.LTweenExe.new(val, parser);
			aux.execute().call();
			_current_tweens_waited[aux.tween.get_instance_id()] = aux.tween;
			await aux.tween.finished;
			_current_tweens_waited.erase(aux.tween.get_instance_id());
			logger.p_log("WAIT %s"%val);
		else:
			logger.err("Tweenput: WAIT -> No internal signal or tween found with name %s."%val);
	elif node is TweenputParser.LVar: # IDs, member access and method calls
		var val = node.value();
		if val is Callable:
			var callable := val as Callable;
			await callable.call();
			logger.p_log("WAIT %s"%callable.get_method());
			return ;
		if val is Signal:
			var sig := val as Signal;
			await sig;
			logger.p_log("WAIT %s"%sig.get_name());
			return ;
		if val is Tween:
			var tween := val as Tween;
			if not tween.is_valid():
				logger.p_log("WAIT (invalid tween)");
				return ;
			if tween.get_loops_left() == -1:
				logger.err("Tweenput: WAIT -> Tried waiting for an infinitely looping Tween.");
				return ;
			if not tween.is_running(): tween.play();
			_current_tweens_waited[tween.get_instance_id()] = tween;
			await tween.finished;
			_current_tweens_waited.erase(tween.get_instance_id());
			logger.p_log("WAIT %s"%node.node_name);
			return ;
		elif val is float:
			await get_tree().create_timer(val).timeout
			logger.p_log("WAIT %s sec"%val);
			return ;
		else:
			logger.err("Tweenput: WAIT -> Parameter is not of type Callable or Signal.");
			return ;
	elif node is TweenputParser.LConst:
		var val = node.value();
		await get_tree().create_timer(val).timeout
		logger.p_log("WAIT %s sec"%val);
		return ;

## Conditional jump to any valid label in the tweenput code.[br][br]
## - [param label]: Label to jump to if the condition is true. (Must have [String] as value)[br]
## - [param condition]: Condition to validate. (Any expression that can be compared)
## [codeblock]
## JMP "label", 1 					# OK
## JMP "label", val					# OK (if the contents of 'val' can be compared)
## JMP "label", val || (val2 > 3)	# OK
## 
## JMP "asd", 1						# ERROR, Unknown label
## JMP "label", true  				# ERROR, true is not a keyword in this language
## 
## ...
## label:
## ...
## [/codeblock]
func __jmp(ctx: Context, label: TweenputParser.LangNode, condition: TweenputParser.LangNode):
	if not label or not condition:
		logger.err("Tweenput: JMP -> Undefined variables.");
		return ;
	
	var label_val = label.value();
	if label_val is not String:
		logger.err("Tweenput: JMP -> 1º argument is not a String (%s)."%label_val);
		return ;
	
	var cond_val = condition.value();
	if cond_val:
		ctx.jmp_target = parser.label_map.get(label_val);
		if not ctx.jmp_target:
			logger.err("Tweenput: JMP -> Label '%s' unknown."%label_val);
			return ;
		ctx.flags |= RUN_FLAG.JUMPING;
	logger.p_log("JMP %s , %s" % [label_val, cond_val as bool]);

## Unconditional jump to a valid label. Includes this instruction in the stack call
## so it can return to this point later.
## Alternativelly if a [Callable] is given, it will call it but won't wait it.[br]
## See also [method __ret].[br][br]
## - [param node]: Can be a [String] or a [Callable].
## [codeblock]
## CALL "function"  	# OK
## SET f, "function"
## CALL f				# OK
## CALL obj.method  	# OK
## CALL callable		# OK
## END
## 
## function:
## ...
## RET
## [/codeblock]
func __call(ctx: Context, node: TweenputParser.LangNode):
	var val = node.value();
	if node is TweenputParser.LString: # Must be label
		ctx.jmp_target = parser.label_map.get(val);
		if ctx.jmp_target:
			ctx.flags |= RUN_FLAG.JUMPING | RUN_FLAG.CALLING;
		else:
			logger.err("Tweenput: CALL -> Label '%s' unknown."%val);
			return ;
	elif node is TweenputParser.LVar: # Value could be Label(String) or Callable still
		if val is Callable:
			val.call(); # Unawaited counterpart of 'WAIT <Callable>' instruction
		elif val is String:
			ctx.jmp_target = parser.label_map.get(val);
			if ctx.jmp_target:
				ctx.flags |= RUN_FLAG.JUMPING | RUN_FLAG.CALLING;
			else:
				logger.err("Tweenput: CALL -> Label '%s' unknown."%val);
				return ;
		else:
			logger.err("Tweenput: CALL -> Parameter must result in a String or Callable.")
			return ;
	else:
		logger.err("Tweenput: CALL -> Only String and Callable are allowed.")
		return ;
	logger.p_log("CALL %s"%val);

## Jumps back to the last instruction in the [member Context.call_stack]. 
## If the stack is empty it will throw an error an end the routine it was executed on.[br]
## See also [method __call].[br][br]
## The following snippet would be valid:
## [codeblock]
## CALL "function"
## END
## 
## function:
## RET				# OK (is reached from CALL "function")
## [/codeblock]
## [br]The following snippet will throw an error and end prematurely:
## [codeblock]
## RET				# ERROR, stack is empty.
## END				# Unreachable
## [/codeblock]
func __ret(ctx: Context):
	var node = ctx.call_stack.pop_back();
	if node:
		ctx.jmp_target = node;
		ctx.flags |= RUN_FLAG.JUMPING;
	else:
		logger.err("Tweenput: RET -> Call stack is empty, cannot return. Ending routine.");
		ctx.flags |= RUN_FLAG.ENDING;
		return ;
	logger.p_log("RET");

## Connects the execution of a Tweenput coroutine to a [Signal].[br][br]
## - [param sig]: The [Signal] to be linked.[br]
## - [param label]: The label the coroutine will start on.[br]
## - (optional) [param oneshot]: Whether the connection will self-disconnect 
## 	 after being called once. [br][br]
## [b]Note:[/b] A signal can be linked to N labels and others signals can link 
## to those same labels too, but you can't link the same signal and label multiple times.
## [codeblock]
## LINK signal, "coroutine"				# OK
## LINK signal, "other_coroutine", 1	# OK
##
## coroutine:
## ...
## END		# Coroutines need END instead of RET
## [/codeblock]
func __link(_ctx: Context,
		sig: TweenputParser.LangNode,
		label: TweenputParser.LangNode,
		oneshot: TweenputParser.LangNode = null):
	# Must have ctx as 1º param because there is an optional parameter (oneshot)
	var sig_val = sig.value();
	var s: Signal;
	if sig_val is String: # Internal signal
		s = _get_add_signal(sig_val);
	elif sig_val is Signal: # External signal
		s = sig_val;
	else:
		logger.err("Tweenput: LINK -> 1º parameter must be Signal.");
		return ;
	
	var lbl_val = label.value();
	if lbl_val is String:
		var sig_flags: int = CONNECT_REFERENCE_COUNTED;
		var is_oneshot: bool = oneshot and (oneshot.value() as bool);
		if is_oneshot:
			sig_flags |= CONNECT_ONE_SHOT;
		var callable := _run_async.bind(lbl_val);
		var sig_name: String = s.get_name();
		var links: CoroutineLinks = _linked_coroutines.get_or_add(sig_name, CoroutineLinks.new());
		links.add(lbl_val, callable);
		s.connect(_run_async.bind(lbl_val), sig_flags);
		logger.p_log("LINK %s , %s, %s" % [sig_name, lbl_val, is_oneshot]);
	else:
		logger.err("Tweenput: LINK -> 2º parameter must be String.");
		return ;

## Disconnects any previously linked label to a [Signal]. 
## If no label is given, it will disconnect ALL labels of the [Signal].[br][br]
## - [param sig]: The [Signal] to be unlinked.[br]
## - (optional) [param label]: The specific label to disconnect.[br]
## [codeblock]
## LINK signal, "c1"
## UNLINK signal, "c1"	# OK
## UNLINK signal, "c2"	# OK but will be ignored
##
## c1:
## END
## c2:
## END
## [/codeblock]
func __unlink(_ctx: Context, sig: TweenputParser.LangNode, label: TweenputParser.LangNode = null):
	var sig_val = sig.value();
	var s: Signal;
	if sig_val is String: # Internal signal
		s = _get_add_signal(sig_val);
	elif sig_val is Signal: # External signal
		s = sig_val;
	else:
		logger.err("Tweenput: UNLINK -> 1º parameter must be Signal.");
		return ;
	
	if label == null: # Disconnect ALL
		var s_name := s.get_name();
		var links: CoroutineLinks = _linked_coroutines.get(s_name, null);
		if links:
			for c in links._callables:
				if s.is_connected(c):
					s.disconnect(c);
			links.clear();
		logger.p_log("UNLINK %s"%s_name);
	else: # Disconnect the Callable of the given Label.
		var lbl_val = label.value();
		if lbl_val is not String:
			logger.err("Tweenput: UNLINK -> 2º parameter must be String.");
			return ;
		var s_name := s.get_name();
		var links: CoroutineLinks = _linked_coroutines.get(s_name, null);
		if links:
			var c := links.get_callable(lbl_val);
			if not c.is_valid():
				logger.p_log("UNLINK (skipped)");
				return ;
			s.disconnect(c);
			links.remove(lbl_val);
		logger.p_log("UNLINK %s , %s" % [s_name, lbl_val]);

## End the execution of the routine it was called on. If called on the main routine,
## it will try to finish the execution of all active coroutines.
func __end(ctx: Context):
	ctx.flags |= RUN_FLAG.ENDING;
	logger.p_log("END");
	return ;


## Adds a QTE with the given parameters to a specific channel (Time unit used is seconds).[br]
## See also [TimeWindow] and [TimeWindowController].[br][br]
## - [param center]: The exact time where the player must send the input.[br]
## - [param radius]: Margin of time where the input is still valid (before and after center).[br]
## - [param pre]: Time where input is still listened but is considered too early.[br]
## - [param post]: Time where input is still listened but is considered too late.[br]
## - [param valid]: Array of [String] with all accepted input actions.[br]
## - [param invalid]: Array of [String] with all rejected input actions.[br]
## - [param channel]: Channel of the [TimeWindowController] where the QTE is assigned.[br]
func __qte(center: TweenputParser.LangNode, radius: TweenputParser.LangNode,
		pre: TweenputParser.LangNode, post: TweenputParser.LangNode,
		valid: TweenputParser.LangNode, invalid: TweenputParser.LangNode,
		channel: TweenputParser.LangNode):
	if not center or not radius or not pre or not post or not valid or not invalid or not channel:
		logger.err("Tweenput: QTE -> Undefined variables.");
		return ;
	
	var v = valid.value();
	if v is not Array:
		logger.err("Tweenput: QTE -> Parameter of accepted input must be an array.");
		return ;
	var accepted: Array[String];
	for action in v:
		if action is String:
			accepted.append(action as String);
		else:
			logger.err("Tweenput: QTE -> Arrays must contain Strings only.");
			return ;
	
	var iv = invalid.value();
	if iv is not Array:
		logger.err("Tweenput: QTE -> Parameter of rejected input must be an array.");
		return ;
	var rejected: Array[String];
	for action in iv:
		if action is String:
			rejected.append(action as String);
		else:
			logger.err("Tweenput: QTE -> Arrays must contain Strings only.");
			return ;
	
	var c := center.value() as float;
	var r := radius.value() as float;
	var la := pre.value() as float;
	var ra := post.value() as float;
	var ch := channel.value() as int;
	var tw := TimeWindow.new(c, r, la, ra, accepted, rejected);
	twc.add_tw(tw, ch);
	logger.p_log("QTE %4.2f %4.2f %4.2f %4.2f %s %s %d" % [c, r, la, ra, accepted, rejected, ch]);

## Waits for the next QTE in the specified channel to yield a result.
## A result is yield if the player press any accepted or rejected input, 
## or if it exits the listening range of the QTE.[br][br]
## - [param channel]: Channel of the [TimeWindowController] where the QTE is assigned.[br]
func __wqte(channel: TweenputParser.LangNode):
	if not channel:
		logger.err("Tweenput: WQTE -> No channel selected for wait.");
		return ;
	var channel_id = channel.value() as int;
	if channel_id is not int:
		logger.err("Tweenput: WQTE -> Channel index must be an integer.");
		return ;
	
	var tw_channel := twc.get_channel(channel_id);
	await tw_channel.processed;
	var result := tw_channel.get_last_processed_value();
	if result == TimeWindow.RESULT.IGNORED:
		push_warning("Tweenput: WQTE -> Retrieved unexpected value.");

	var res_dict: Dictionary = parser.variables.get_or_add("res_qte", {});
	res_dict[channel_id] = result;
	logger.p_log("WQTE %d (%s)" % [channel_id, TimeWindow.RESULT.find_key(result)]);

## Stops and emits the [signal Tween.finished] signal of the given [Tween]. [br]
## Prefer this instruction to using [code] CALL tween.stop [/code] because [method Tween.stop]
## doesn't emits the [signal Tween.finished] signal and instructions that wait tweens
## won't work propertly when said tweens are stoped.[br][br]
## - [param node_t]: [Tween] to stop. Cannot be a [String].
func __stop(node_t: TweenputParser.LangNode):
	if not node_t:
		logger.err("Tweenput: STOP -> Undefined variables.");
		return ;
	var tween = node_t.value();
	if tween is not Tween:
		logger.err("Tweenput: STOP -> Parameter must be a tween.");
		return ;
	var t := (tween as Tween)
	t.stop();
	t.finished.emit();
	logger.p_log("STOP %s"%node_t.node_name);

## Waits until the specified input action is registered. [br][br]
## - [param input]: The name of the input action to wait for.[br]
## - [param release]: Whether to wait for the pressed or released event (default to pressed).
func __winput(_ctx: Context, input: TweenputParser.LangNode, release: TweenputParser.LangNode = null):
	if not input:
		logger.err("Tweenput: WINPUT -> Undefined variable.");
		return ;
	var input_action = input.value();
	if input_action is not String:
		logger.err("Tweenput: WINPUT -> First parameter must be a String.");
		return ;
	if not InputMap.has_action(input_action):
		logger.err("Tweenput: WINPUT -> Action '%s' is not registered in the InputMap."
			%input_action);
		return ;
	
	var is_release: bool = release and release.value();
	if is_release:
		if not _waiting_actions_release.has(input_action):
			_waiting_actions_release.append(input_action);
	else:
		if not _waiting_actions_press.has(input_action):
			_waiting_actions_press.append(input_action);
	
	var wait: bool = true;
	while wait:
		await _input_found;
		if is_release:
			if input_action not in _waiting_actions_release:
				wait = false;
		else:
			if input_action not in _waiting_actions_press:
				wait = false;
	logger.p_log("WINPUT %s %s" % [input_action, is_release]);

#endregion

## Series of procedures to ensure most waiting instructions stop waiting 
## when the interpreter wants to end all execution of co-routines.
func _cleaning_execution():
	# Uncloging signal dependent waiting instructions
	# WINPUT
	_waiting_actions_release.clear();
	_waiting_actions_press.clear();
	_input_found.emit();
	# WQTE
	for c in twc._channels:
		twc.get_channel(c).processed.emit();
	# WAIT (internal signals only)
	for sig in _internal_signals.values():
		(sig as Signal).emit();
	# WAIT (any awaited Tween)
	for val in _current_tweens_waited.values():
		var t := val as Tween;
		t.stop();
		t.finished.emit();

## Retrieve (and create dynamically if necessary) signals from the interpreter.
func _get_add_signal(sig_name: String) -> Signal:
	var s: Signal;
	if not self.has_user_signal(sig_name):
		self.add_user_signal(sig_name);
		s = Signal(self, sig_name);
		_internal_signals[sig_name] = s;
	else:
		s = _internal_signals[sig_name];
	return s;

func _set_tw_process(val: bool):
	_processing_tw = val;
	if val:
		twc.clear_channels();
		_tw_start = 0;

## Retrieve one free coroutine ID from the pool (up to [member max_active_coroutines]).
func _get_id_from_pool() -> int:
	if _id_pool.size() == 0: return -1;
	return _id_pool.pop_back();

## Returns a coroutine ID to the pool.
func _release_id_to_pool(id: int) -> void:
	if id in _id_pool: return ;
	_id_pool.append(id);
	_coroutine_finished.emit();
	#logger.p_log("New size: ",_id_pool.size());
