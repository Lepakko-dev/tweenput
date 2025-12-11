# Tweenput (Godot 4.5+)

An addon for [Godot 4.5+](https://godotengine.org/) that unifies the official Tween class in Godot and a simple Quick Time Event system in a text-based scripting language that dynamically creates and updates Tweens.

To install the plugin you can download a copy and put the `addons/tweenput/` directory into your project's `addons` directory.
Then open your project's settings and enable 'Tweenput' in the Plugins tab.

## Features

- Assembly inspired grammar with support for C-like expressions.
- Create and execute tweens whose parameters can update each time they are played.
- Set time intervals to listen to any specific input press to create quick time events.
- Include any type of object in the interpreter's available variables to access and modify them inside the code.
- Create coroutines that execute any parts of the tweenput code.
- Write comments in the code.

## Documentation

W.I.P

### Instruction Set
- `SET <variable>, <expression>`: Calculates the value of the expression and assigns it to the variable. 
- `SWAP <variable>, <variable>`: Swaps the values between two variables.
- `EMIT <signal>`: Emits a signal (works for signals inside and outside the interpreter).
- `WAIT <...>`: Waits for the given signal, callable, tween or time.
- `JMP <label>, <expression>`: Jumps to the given label if the condition is true.
- `CALL <...>`: Calls any specified method or callable, or jumps to a label as a sub-routine.
- `RET`: Exit the current sub-routine jumping to the next node after the last `CALL` instruction.
- `LINK <signal>, <label>, <bool>`: Connects a label to the given signal starting a coroutine when emited. Last parameter is optional and makes the connection to be `oneshot`.
- `UNLINK <signal>, <label>`: Disconnects a label to the signal. Disconnect all labels if no label is given.
- `END`: Finish the execution of any coroutine. If used in the main routine, will try to stop any active coroutine.
- `QTE <center:float>, <radius:float>, <pre:float>, <post:float>, <accepted:Array[String]>, <rejected:Array[String], <channel:int>`: Queues a `TimeWindow` with the given parameters into the specified channel. Listens to player input.
- `WQTE <channel:int>`: Waits until the earliest `TimeWindow` in the channel has yielded any result.
- `STOP <tween>`: Stops the given tween and emits its `finished` signal.
- `WINPUT <string>, <bool>`: Waits indefinitely until the specified input action is `pressed`. Will check `released` instead if the optional second parameter is true.

## Roadmap

Main functionality is done, but there's still some work to do in order to make this a "good" open source project.
In order of priority:
- Example scenes showing the use of the plugin.
- Full documentation of the plugin (including design).
- Code editor integration for Godot with syntax highlighting.
- Unit testing.
- Upload to the Godot Asset Library.

I will deal with any potential bugs or issues during this process, but enhancements will be put on hold until unit testing is completed.