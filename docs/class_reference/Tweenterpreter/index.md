---
layout: default-title
title: Tweenterpreter
parent: Class Reference
has_toc: false
---

Extends [Node]

Handles and run Tweenput code.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [debug](#debug) | [bool] | `` |
| [logger](#logger) | [TweenputLogger] | `` |
| [parser](#parser) | [TweenputParser] | `` |
| [twc](#twc) | [TimeWindowController] | `` |
| [_processing_input](#_processing_input) | [bool] | `` |
| [_tw_start](#_tw_start) | [int] | `` |
| [max_active_coroutines](#max_active_coroutines) | [int] | `16` |
| [_ctx_list](#_ctx_list) | [Array]\[[Context]\] | `` |
| [_internal_signals](#_internal_signals) | [Dictionary]\[[String], [Signal]\] | `` |
| [_linked_coroutines](#_linked_coroutines) | [Dictionary]\[[String], [CoroutineLinks]\] | `` |
| [_id_pool](#_id_pool) | [Array]\[[int]\] | `` |
| [timeout_waiting_list](#timeout_waiting_list) | [Array]\[[SceneTreeTimer]\] | `` |
| [_current_tweens_waited](#_current_tweens_waited) | [Dictionary]\[[int], [Tween]\] | `` |
| [_waiting_actions_press](#_waiting_actions_press) | [Array]\[[String]\] | `` |
| [_waiting_actions_release](#_waiting_actions_release) | [Array]\[[String]\] | `` |
| [_pressed_actions_to_signals](#_pressed_actions_to_signals) | [Dictionary]\[[String], [Signal]\] | `` |
| [_released_actions_to_signals](#_released_actions_to_signals) | [Dictionary]\[[String], [Signal]\] | `` |
| [instructions](#instructions) | [Dictionary]\[[String], [Callable]\] | `{"SET": __set,"SWAP": __swap,# Flow of Execution Related"EMIT": __emit,"WAIT": __wait,"JMP": __jmp,"CALL": __call,"RET": __ret,"SINPUT": __sinput,"LINK": __link,"UNLINK": __unlink,"END": __end,# Other Animation Related"QTE": __qte,"WQTE": __wqte,"STOP": __stop,"WINPUT": __winput,}` |

# Methods

| Return Type | Name |
|:-|:-|
| [String] | [process_code](#process_code)(code: [String]) |
|  | [run](#run)() |
| void | [set_variable](#set_variable)(var_name: [String], value: [Variant]) |
| void | [_init](#_init)() |
| void | [_ready](#_ready)() |
| [PackedStringArray] | [_get_configuration_warnings](#_get_configuration_warnings)() |
| void | [_unhandled_input](#_unhandled_input)(event: [InputEvent]) |
| void | [_process](#_process)(_delta: [float]) |
|  | [_run_async](#_run_async)(label: [String]) |
| [TweenputParser.LInstr] | [_step](#_step)(node: [TweenputParser.LInstr], ctx: [Context]) |
|  | [__set](#__set)(id: [TweenputParser.LangNode], expr: [TweenputParser.LangNode]) |
|  | [__swap](#__swap)(a: [TweenputParser.LangNode], b: [TweenputParser.LangNode]) |
|  | [__emit](#__emit)(sig_node: [TweenputParser.LangNode]) |
|  | [__wait](#__wait)(node: [TweenputParser.LangNode]) |
|  | [__jmp](#__jmp)(ctx: [Context], label: [TweenputParser.LangNode], condition: [TweenputParser.LangNode]) |
|  | [__call](#__call)(ctx: [Context], node: [TweenputParser.LangNode]) |
|  | [__ret](#__ret)(ctx: [Context]) |
|  | [__unlink](#__unlink)(_ctx: [Context], sig: [TweenputParser.LangNode], label: [TweenputParser.LangNode] = null) |
|  | [__end](#__end)(ctx: [Context], force_all: [TweenputParser.LangNode] = null) |
|  | [__wqte](#__wqte)(channel: [TweenputParser.LangNode]) |
|  | [__stop](#__stop)(node_t: [TweenputParser.LangNode]) |
|  | [__winput](#__winput)(_ctx: [Context], input: [TweenputParser.LangNode], release: [TweenputParser.LangNode] = null) |
|  | [_pre_execution_tasks](#_pre_execution_tasks)() |
|  | [_cleaning_execution](#_cleaning_execution)() |
| [Signal] | [_get_add_signal](#_get_add_signal)(sig_name: [String]) |
|  | [_set_input_processing](#_set_input_processing)(val: [bool]) |
|  | [_update_time](#_update_time)() |
| [int] | [_get_id_from_pool](#_get_id_from_pool)() |
| void | [_release_id_to_pool](#_release_id_to_pool)(id: [int]) |

# Inner Classes

- [Context]
- [CoroutineLinks]

# Signals

_coroutine_finished()
: Emitted when a coroutine has finished its execution
 (used by the main routine to avoid dangling coroutines)

_input_found()
: Emitted when an input (this interpreter is waiting for) has been pressed or released.

# Enumerations

enum RUN_FLAG:
{: #RUN_FLAG }
Flags to control the interpreter's flow of execution.

> JUMPING = 1
> {: #RUN_FLAG.JUMPING }
> > Jump to another instruction.

> CALLING = 2
> {: #RUN_FLAG.CALLING }
> > Uses the call stack.

> ENDING = 4
> {: #RUN_FLAG.ENDING }
> > End execution.

# Property Descriptions

[bool] debug
{: #debug }


---

[TweenputLogger] logger
{: #logger }


---

[TweenputParser] parser
{: #parser }

> Parser needed to process tweenput code into an AST (Abstract Syntax Tree)

---

[TimeWindowController] twc
{: #twc }

> Controller for QTEs used during code execution.

---

[bool] _processing_input
{: #_processing_input }

> Indicates whether the [TimeWindowController] is active.

---

[int] _tw_start
{: #_tw_start }

> Relative timestamp for the 0 seconds mark of the [TimeWindowController].

---

[int] max_active_coroutines = ```16```
{: #max_active_coroutines }

> Max number of active coroutines at a time (excluding the main routine).

---

[Array]\[[Context]\] _ctx_list
{: #_ctx_list }

> List of context per coroutine.

---

[Dictionary]\[[String], [Signal]\] _internal_signals
{: #_internal_signals }

> Map of disposable signals created during execution

---

[Dictionary]\[[String], [CoroutineLinks]\] _linked_coroutines
{: #_linked_coroutines }

> Maps name of signal being listened for coroutine executions.

---

[Array]\[[int]\] _id_pool
{: #_id_pool }

> Pool of free coroutine IDs.

---

[Array]\[[SceneTreeTimer]\] timeout_waiting_list
{: #timeout_waiting_list }


---

[Dictionary]\[[int], [Tween]\] _current_tweens_waited
{: #_current_tweens_waited }

> Maps the instance id of each tween being waited.

---

[Array]\[[String]\] _waiting_actions_press
{: #_waiting_actions_press }

> Stores input actions that need to be listened on press.

---

[Array]\[[String]\] _waiting_actions_release
{: #_waiting_actions_release }

> Stores input actions that need to be listened on release.

---

[Dictionary]\[[String], [Signal]\] _pressed_actions_to_signals
{: #_pressed_actions_to_signals }


---

[Dictionary]\[[String], [Signal]\] _released_actions_to_signals
{: #_released_actions_to_signals }


---

[Dictionary]\[[String], [Callable]\] instructions = ```{"SET": __set,"SWAP": __swap,# Flow of Execution Related"EMIT": __emit,"WAIT": __wait,"JMP": __jmp,"CALL": __call,"RET": __ret,"SINPUT": __sinput,"LINK": __link,"UNLINK": __unlink,"END": __end,# Other Animation Related"QTE": __qte,"WQTE": __wqte,"STOP": __stop,"WINPUT": __winput,}```
{: #instructions }

> Implementation of the instruction set allowed in the Tweenput code.

---

# Method Descriptions

[String] process_code(code: [String])
{: #process_code }

> Updates the AST of the interpreter with the new code.<br><br>
 <b>Note:</b> Must be called at least once before running this interpreter.

---

 run()
{: #run }

> Starts the execution of the tweenput code.<br><br>
 <b>Note:</b> This is a coroutine, can be awaited.

---

void set_variable(var_name: [String], value: [Variant])
{: #set_variable }


---

void _init()
{: #_init }


---

void _ready()
{: #_ready }


---

[PackedStringArray] _get_configuration_warnings()
{: #_get_configuration_warnings }


---

void _unhandled_input(event: [InputEvent])
{: #_unhandled_input }


---

void _process(_delta: [float])
{: #_process }


---

 _run_async(label: [String])
{: #_run_async }

> Coroutine that executes Tweenput code from a specific label.

---

[TweenputParser.LInstr] _step(node: [TweenputParser.LInstr], ctx: [Context])
{: #_step }

> Executes a single instruction node and handle any set execution flags.

---

 __set(id: [TweenputParser.LangNode], expr: [TweenputParser.LangNode])
{: #__set }

> Assign a new value to the specified variable (an array element can be assigned too).<br><br>
 - ```id```: Node representing the variable to be assigned to.<br>
 - ```expr```: Any expression that results into any [Variant] value.
 ```
 SET var1, 1;				 OK
 SET var1, var2;			 OK
 SET array[0], var1;		 OK
 SET array[idx], var1; 	 OK
 SET var1.member, var2;	 OK
 SET var1, var2 + 10;		 OK

 SET 1, variable;			 ERROR
 SET var1.method(), var2;	 ERROR
 SET var1 + 10, var2;		 ERROR
 ```

---

 __swap(a: [TweenputParser.LangNode], b: [TweenputParser.LangNode])
{: #__swap }

> Swap the contents of any pair of variables.<br><br>
 - ```a```: Node representing a variable.<br>
 - ```b```: Node representing a variable.<br><br>
 <b>Note:</b> Won't swap members.
 ```
 SWAP var1, var2 			 OK

 SWAP var1.member, var2 	 ERROR
 SWAP var1, "string" 		 ERROR
 ```

---

 __emit(sig_node: [TweenputParser.LangNode])
{: #__emit }

> Emits the given signal (both internal or external).<br><br>
 - ```sig_node``` Node whose value must be a [Signal] or a [String].<br>
 ```
 EMIT "internal_sig"  		 OK

 SET variable, "i_sig"
 EMIT variable				 OK

 EMIT external_signal 		 OK if the variant is of type Signal.

 SET variable, 10
 EMIT variable		 		 ERROR
 ```

---

 __wait(node: [TweenputParser.LangNode])
{: #__wait }

> Pauses the current routine depending on the type of the ```node```'s value:<br>
 - If [String]: If it's a [Signal] waits it, if it's a [Tween] play & waits it.<br>
 - If [Callable]: Waits until the callable finishes its execution.<br>
 - If [Signal]: Waits until the signal is emitted.<br>
 - If [Tween]: Plays the tween and waits for it to finish (Skips if invalid).<br>
 - If [float]: Waits the ammount of time in seconds.
 ```
 WAIT 1.0 				 OK
 WAIT 1					 OK (Implicit conversion)
 WAIT "signal"			 OK
 WAIT "tween" 			 OK (will rebuild the tween)
 WAIT tween				 OK
 WAIT object.method		 OK
 WAIT object.signal		 OK
 ```

---

 __jmp(ctx: [Context], label: [TweenputParser.LangNode], condition: [TweenputParser.LangNode])
{: #__jmp }

> Conditional jump to any valid label in the tweenput code.<br><br>
 - ```label```: Label to jump to if the condition is true. (Must have [String] as value)<br>
 - ```condition```: Condition to validate. (Any expression that can be compared)
 ```
 JMP "label", 1 					 OK
 JMP "label", val					 OK (if the contents of 'val' can be compared)
 JMP "label", val || (val2 > 3)	 OK
 
 JMP "asd", 1						 ERROR, Unknown label
 JMP "label", true  				 ERROR, true is not a keyword in this language
 
 ...
 label:
 ...
 ```

---

 __call(ctx: [Context], node: [TweenputParser.LangNode])
{: #__call }

> Unconditional jump to a valid label. Includes this instruction in the stack call
 so it can return to this point later.
 Alternativelly if a [Callable] is given, it will call it but won't wait it.<br>
 See also [__ret](#__ret).<br><br>
 - ```node```: Can be a [String] or a [Callable].
 ```
 CALL "function"  	 OK
 SET f, "function"
 CALL f				 OK
 CALL obj.method  	 OK
 CALL callable		 OK
 END
 
 function:
 ...
 RET
 ```

---

 __ret(ctx: [Context])
{: #__ret }

> Jumps back to the last instruction in the [Context.call_stack][Tweenterpreter.Context#call_stack]. 
 If the stack is empty it will throw an error an end the routine it was executed on.<br>
 See also [__call](#__call).<br><br>
 The following snippet would be valid:
 ```
 CALL "function"
 END
 
 function:
 RET				 OK (is reached from CALL "function")
 ```
 <br>The following snippet will throw an error and end prematurely:
 ```
 RET				 ERROR, stack is empty.
 END				 Unreachable
 ```

---

 __unlink(_ctx: [Context], sig: [TweenputParser.LangNode], label: [TweenputParser.LangNode] = null)
{: #__unlink }

> Disconnects any previously linked label to a [Signal]. 
 If no label is given, it will disconnect ALL labels of the [Signal].<br><br>
 - ```sig```: The [Signal] to be unlinked.<br>
 - (optional) ```label```: The specific label to disconnect.<br>
 ```
 LINK signal, "c1"
 UNLINK signal, "c1"	 OK
 UNLINK signal, "c2"	 OK but will be ignored

 c1:
 END
 c2:
 END
 ```

---

 __end(ctx: [Context], force_all: [TweenputParser.LangNode] = null)
{: #__end }

> End the execution of the routine it was called on. If called on the main routine,
 it will try to finish the execution of all active coroutines.

---

 __wqte(channel: [TweenputParser.LangNode])
{: #__wqte }

> Waits for the next QTE in the specified channel to yield a result.
 A result is yield if the player press any accepted or rejected input, 
 or if it exits the listening range of the QTE.<br><br>
 - ```channel```: Channel of the [TimeWindowController] where the QTE is assigned.<br>

---

 __stop(node_t: [TweenputParser.LangNode])
{: #__stop }

> Stops and emits the [Tween.finished] signal of the given [Tween]. <br>
 Prefer this instruction to using ``` CALL tween.stop ``` because [Tween.stop]
 doesn't emits the [Tween.finished] signal and instructions that wait tweens
 won't work propertly when said tweens are stoped.<br><br>
 - ```node_t```: [Tween] to stop. Cannot be a [String].

---

 __winput(_ctx: [Context], input: [TweenputParser.LangNode], release: [TweenputParser.LangNode] = null)
{: #__winput }

> Waits until the specified input action is registered. <br><br>
 - ```input```: The name of the input action to wait for.<br>
 - ```release```: Whether to wait for the pressed or released event (default to pressed).

---

 _pre_execution_tasks()
{: #_pre_execution_tasks }

> Resets coroutine id pool, contexts, and input related lists.

---

 _cleaning_execution()
{: #_cleaning_execution }

> Series of procedures to ensure most waiting instructions stop waiting 
 when the interpreter wants to end all execution of co-routines.
 Ends relations with signals too.

---

[Signal] _get_add_signal(sig_name: [String])
{: #_get_add_signal }

> Retrieve (and create dynamically if necessary) signals from the interpreter.

---

 _set_input_processing(val: [bool])
{: #_set_input_processing }


---

 _update_time()
{: #_update_time }

> Sets the value of a parser variable called "time" with the elapsed seconds since the start of the Tweenput.

---

[int] _get_id_from_pool()
{: #_get_id_from_pool }

> Retrieve one free coroutine ID from the pool (up to [max_active_coroutines](#max_active_coroutines)).

---

void _release_id_to_pool(id: [int])
{: #_release_id_to_pool }

> Returns a coroutine ID to the pool.

---

[Tweenterpreter]: Tweenterpreter
[Context]: Context
[CoroutineLinks]: CoroutineLinks

[Tweenterpreter.Context.call_stack]: /class_reference/Tweenterpreter/Context/call_stack
[TimeWindowController]: /class_reference/TimeWindowController
[TweenputParser]: /class_reference/TweenputParser
[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode
[TweenputParser.LInstr]: /class_reference/TweenputParser/LInstr
[TweenputLogger]: /class_reference/TweenputLogger

[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[bool]: https://docs.godotengine.org/en/stable/classes/class_bool.html
[int]: https://docs.godotengine.org/en/stable/classes/class_int.html
[float]: https://docs.godotengine.org/en/stable/classes/class_float.html
[Signal]: https://docs.godotengine.org/en/stable/classes/class_signal.html
[InputEvent]: https://docs.godotengine.org/en/stable/classes/class_inputevent.html
[Node]: https://docs.godotengine.org/en/stable/classes/class_node.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html
[Tween.stop]: https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-stop
[Tween.finished]: https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-signal-finished
[SceneTreeTimer]: https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html
[PackedStringArray]: https://docs.godotengine.org/en/stable/classes/class_packedstringarray.html

