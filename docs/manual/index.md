---
layout: default
title: Manual
nav_order: 2
has_toc: true
---

# Instruction Set
The general grammar for all instructions in Tweenput follows the structure `INSTR PARAM , PARAM , ...`.
Each instruction has a specific number of accepted parameters although some can be omitted in certain cases.

**Note:** When reffering to *internal* or *external* elements of a Tweensput it is regarded as created inside the Tweenput or outside one, respectively.

## SET
Assign a new value to the specified variable.
(**2** parameters)

The first parameter must be an expression that yields a variable (an array element can be assigned too), while the second one can be any type of expression that yields some value of any type.
### Use Examples
~~~
SET var1, 1;			# OK
SET var2, var1;			# OK
SET array[0], var1;		# OK
SET array[idx], var1; 	# OK
SET var1.member, var2;	# OK
SET var1, var2 + 10;	# OK

SET 1, variable;		# INVALID
SET var1.method(), var2;# INVALID
SET var1 + 10, var2;	# INVALID
~~~
## SWAP
Swap the contents of any pair of variables.
(**2** parameters)

Both parameters must be variables.

**Note:** Won't swap member values.
### Use Examples
~~~
SWAP var1, var2 		# OK
SWAP var1.member, var2 	# INVALID
SWAP var1, "string" 	# INVALID
~~~
## EMIT
Emits the given signal (both internal or external).
(**1** parameter)

The parameter must yield a signal of any type. It will be emitted without parameters.
### Use Examples
~~~
EMIT "internal_sig"  		# OK
SET variable, "i_sig"
EMIT variable				# Also OK, variable holds signal.
EMIT external_signal 		# OK if the variant is of type Signal.
                            # Checked at runtime.
SET variable, 10
EMIT variable		 		# INVALID
~~~
## WAIT
Pauses the current routine. Can accept a variety of types.
(**1** parameter)

Action based on parameter type:
- (*Float*) Pauses the routine the given ammount in seconds.
- (*String*) Checks for any internal Signal or internal Tween. If it's a Signal it will await it. If it's a Tween it will play and wait for it to finish.
- (*Callable*) Calls and awaits the given Callable. 
- (*Signal*) Awaits the Signal (external or internal if assigned to a variable).
- (*Tween*) Plays the Tween and Waits it to finish.

**Note:** Any called internal tween will rebuild itself each time it's executed automatically.
### Use Examples
~~~
WAIT 1.0 				# OK (float)
WAIT 1					# OK (Implicit conversion to float)
WAIT "signal"			# OK (internal signal)
WAIT "tween" 			# OK (internal tween)
WAIT tween				# OK (external tween)
WAIT object.method		# OK (Treated as Callable)
WAIT object.signal		# OK (External signal)
~~~
## JMP
Conditional jump to any valid label in the tweenput code. If the condition doesn't validates to true, it goes to the next instruction.
(**2** parameters)

First parameter is the label to jump to if the condiction validates as true. Any expression that yields a String is valid.
The second parameter is the condition to validate, which can be any expression that can be compared.
### Use Examples
~~~
JMP "label", 1 					# OK (Always true)
JMP "label", val				# OK (if the contents of 'val' can be compared)
JMP "label", val || (val2 > 3)	# OK

JMP "asd", 1					# INVALID, Unknown label
JMP "label", true  				# INVALID, 'true' and 'false' are not valid keywords in this language.

label:
~~~
## CALL
Unconditional jump to a valid label or un-awaited call.
(**1** parameter)

If the expression given was a String, it'll be treated as a Label to jump to, this instruction will be included in the stack call so it can *return* to this point later.

Alternativelly if a Callable is given, it will call it but won't await if it's an async method.
### Use Examples
~~~
CALL "function"  	# OK
SET f, "function"
CALL f				# OK (Jump to label "function")
CALL callable		# OK
CALL obj.method  	# OK (Method treated as Callable)
END

function:
RET
~~~
## RET
Jumps back to the last instruction pushed to the call stack.
If the stack is empty it will throw an error an end the routine it was executed on.
(**0** parameters)

The following snippet would be valid:
### Use Examples
~~~
CALL "function"
END

function:
SET a, 0
RET				# OK (is reached from CALL "function")
~~~
It will have the order of execution: CALL -> SET -> RET -> END.

The following snippet will throw an error and end prematurely:
~~~
RET				# ERROR, stack is empty.
END				# Unreachable
~~~
## SINPUT
Connects the press or release of an input action to a Signal emission.
(**3** parameters)

While an input action is connected to a Signal, the activation of the input will emit the given Signal.

First parameter is the name of the input action to listen to.
Second parameter is the signal (both internal and external are valid).
Third parameter tells whether to listen to the press or the release of the input. This last parameter is optional and will listen to presses by default.

Multiple input can be linked to the same signal, but multiple signals ***cannot*** be connected to the same input.
The exeption is that presses and releases connections are independent of each other.
### Use Examples
~~~
SINPUT "ui_up", "i_signal" 		# OK
SINPUT "ui_up", "i_signal", 1	# OK, now the signal is emited for presses and releases.
SINPUT "ui_down", ext_signal 	# OK
SINPUT "ui_down", "i_signal" 	# OK, replaces previous connected signal.
SINPUT "ui_up", ""				# OK, removes connection with the input (for press only in this case).
END		# Removes relations with all input actions remaining.
~~~
## LINK
Links the execution of a Tweenput coroutine to a Signal.
(**3** parameters)

First parameter must be a Signal to link to.
Second parameter must be a String with the name of a label to use as starting point for the coroutine.
Third parameter tells whether the link should be oneshot or not (Self-disconnects after first execution). This last parameter is optional.

**Note:** The relation of links between signals and labels is N-N (a signal can connect to multiple labels and viceversa), but each pair *must* be unique.

**Note:** All Tweenput has a maximum of concurrent coroutines. If this limit is reached, any attempt to create another coroutine will be ignored.
### Use Examples
~~~
LINK signal, "coroutine"			# OK
LINK signal, "other_coroutine", 1	# OK, this link will be deleted after first emission of signal.

other_coroutine:
coroutine:
END		# Coroutines need to END instead of RET
~~~
## UNLINK
Disconnects any previously linked label to a Signal.
(**2** parameters)

First paramter is the signal to unlink to.
Second parameter is the label used for the coroutine that will be disconnected. If no label is given, it will disconnect ALL coroutines to the Signal.
### Use Examples
~~~
LINK signal, "c1"
UNLINK signal, "c1"	# OK
UNLINK signal, "c2"	# OK but will be ignored
c1:
END
c2:
END
~~~
## END
End the execution of the routine it was called on.
(**1** parameters)

The only parameter is optional, must be an expression that evaluates to true and tries to finish the execution of all active coroutines if called on the main routine.

## QTE
Adds a Time Window with the given parameters to a specific channel (Time unit in seconds).
(**6** parameters)


Parameters in order:
- center: The exact time where the player must send the input.
- radius: Margin of time where the input is still valid (before and after the center).
- pre: Extra time where input is still listened but considered too early.
- post: Extra time where input is still listened but considered too late.
- valid: Array with all accepted input actions as Strings.
- invalid: Array with all rejected input actions as String (if any).
- channel: Channel where the Time Window is assigned.

Time Windows cannot overlap (and will adapt to fit with eachother if necessary), but each channel is independent.
## WQTE
Waits for the next Time Window to yield a result in a specific channel.
(**1** parameters)

A result is yield when the player presses any accepted or rejected input, or if the earliest Time Window ends.

The only parameter is the Channel (integer) to wait to.
## STOP
Stops and emits the `Tween.finished` signal of the given Tween.
(**1** parameters)

Prefer this instruction to using `CALL tween.stop` because the stop method won't emit the `Tween.finished` signal and instructions that wait tweens won't work properly when said tweens are stoped.

The only parameter must yield a variable of type Tween.
## WINPUT
Waits until the specified input action is registered.
(**2** parameters)

First parameter is a String with the name of an input action.
Second parameter is an expression that must be comparable. Said value will indicate whether to wait for the press or release of the input action (optional, defaults to pressed).
# Defining and Using Tweens Inside a Tweenput

TODO TODO TODO TODO TODO TODO 

# Adding External Variables to a Tweenput and Retrieving them
If you have alreay been through the [Getting Started](GettingStarted) page, you may have seen how we can include external variables from your game to the tweenput with the `set_variable()` or `set_variables()` methods of the [Tweenterpreter]. This is necessary in order to give the tweenput access to other nodes.

What's helpful is we can also read ANY value inside a tweenput as all variables (including internal ones) are stored in the [Tweenterpreter]`.parser.variables` member. Retrieval of data is also necessary when we want for example to know if the player succeeded or failed some input press.

All variables have a name and can store any type of value, just as `Variant` can!
# Time Windows (Quick Time Events)
The Time Window is a data structure that stores which input must or not be pressed in a specific time span. This time span is given as a specific time (referred as the `center`), and a `radius` (or range) that expands before and after that center.

Time Windows also include an external range for each side which we'll call "left arm" and "right arm". These will help check if an input was pressed too early or too late, and by extension deter whether the player failed or just didn't press anything at all. You can think of these "arms" as times where the player must NOT press the input for that Time Window.

When we want to setup more than one Time Window we may encouter a problem where two Time Windows overlap in some way, this is mitigated automatically as two time windows will equally give in part of their range in a balanced way until none overlap. This is done in two steps, first it will try to shrink the arms that overlap, without changing the radius. If the overlap still exist, then it'll shrink both centers equally until the overlap ceases.

This "keep radius size policy" is thought out for Tweenputs where a series of inputs are requested increasingly faster every time, like for those special/combo/brother attacks in any Mario & Luigi RPG.

Okay, but what if I want the player to press more than one input at a given time? You may ask. Don't worry, that's what the channels are for. When defining a Time Window you can also specify which channel to be included in. All channels are independent of each other so two Time Windows in different channels won't count as an overlap and therefore won't shrink each other.

Lastly, just remark that Time Windows defined with the `QTE` instruction are always relative to the time when the tweenput started. So a Time Window of center 0.5 will be checked 0.5 seconds after the tweenput was executed.

(Of course, any Time Window defined with a time in the past will be ignored as we haven't invented yet time travel and we can only move forward.)
# Other

## Call Stack

## Co-routines

## Other Variables
Inside of every Tweenput there is also some variables that are always present and automatically handled. 
Even if you can assign data on them, it is not recomended as the interpreter will override them at some point, so you should consider these variables as **read only**.
### Internal `time`
This variable is constantly updated to hold the elapsed time since the start of the Tweenput.
(Time measured in seconds)
### Internal `res_qte`
This variable holds the result of the last finished Time Window for every channel.
It takes the form of a dictionary where keys are channels and the values are the result of the last finished Time Window (success, fail, miss, étc) as an integer.
The types of result of a Time Window follow the RESULT enum, here's the list of integer values each type of result is represented as:
- CORRECT = 1
- IGNORED = 0 (No relevant input has been pressed while the TW is active)
- TOO_LATE = -1 (Some input was pressed after the radius)
- TOO_EARLY = -2 (Some input was pressed before the radius)
- REJECTED = -3 (Some input that was to be avoided was pressed)
- OUTSIDE = -4 (No relevant input was pressed and the TW finished)

[GettingStarted]: ...
[Tweenterpreter]: ...