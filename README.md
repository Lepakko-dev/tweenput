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

## Roadmap

Main functionality is done, but there's still some work to do in order to make this a "good" open source project.
In order of priority:
- Example scenes showing the use of the plugin (1/3).
- Full documentation of the plugin (including design).
- Code editor integration for Godot with syntax highlighting.
- Unit testing.
- Upload to the Godot Asset Library.

I will deal with any potential bugs or issues during this process, but enhancements will be put on hold until unit testing is completed.