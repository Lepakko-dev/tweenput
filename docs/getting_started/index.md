---
layout: default
title: Getting Started
nav_order: 1
has_toc: true
---

# Installation
Tweenput is built using only GDScript and doesn't use any autoloads which means its setup it's as simple as just drag & drop the files into the addons directory and enabling it in the `Project -> Project Settings -> Pluings` tab.
The directory structure should look like the following:
```
res://
|   addons
|   |   tweenput
|   |   |   examples
|   |   |   |   ...
|   |   |   QTE
|   |   |   |   ...
|   |   |   plugin.cfg
|   |   |   tweenput.gd
|   |   |   ...
```

# How To Use
To execute Tweenput code you need to instantiate an interpreter node in the scene you want to use it.
The default interpreter is called [Tweenterpreter].

Now that we have our node set we can continue to the next step, actually writing Tweenput code!

# Writing Tweenput Code
The interpreter does nothing by itself except for instantiating at runtime its own Parser if none is added as a child.
(A parser reads the actual Tweenput code and makes a data structure based on that code. This structure is then used by the interpreter to run the instructions written in the code.)

In order for it to do something we need to give it some Tweenput code and then run it.

Let's write something simple as an example. Maybe we want the player to press some key after a second has passed, for this we should use some visual feedback to the player, both during and after the QTE. 

Let's make a sprite shrink in size and then change color based on the results (player pressed key after a second, or not). Let's also give it some room for checking the input so the player doesn't have to make a frame perfect input...
```
# Example Tweenput Code

# Sets up the Quick Time Event.
QTE 0.95, 0.1, -0.9, 0.2, ["ui_up"],[], 0

# Executes tween and waits for the qte to yield results.
shrink
WQTE 0
STOP shrink

# Check result of QTE and change sprite's color.
JMP "ok", res_qte[0] == 1
WAIT "fail"
END

ok:
WAIT "success"
END

# Defining Tweens used
shrink{
    property sprite, "global_scale", Vector2(0,0), 1
}
success{
    property sprite, "self_modulate", Color(0.15,1.0,0.15,1), 0.20
}
fail{
    property sprite, "self_modulate", Color(0,0,0,0), 0.20
}
```
## Explanation
The first instruction (**QTE**) creates a **TimeWindow** which schedules some input check for a given time. In this case corresponds to the `"ui_up"` input action, `0.95` seconds from said instruction, letting the player a margin of `0.1` seconds before and after. You can know more about the available instructions here: [Instructions].
For a finer explanation about Time Windows, please go to [TimeWindow].

Let's jump straight to the end were we have defined some tweens. These tweens are defined similarly to how one would do it the normal way, except these Tweens can be played more than once and any variable used is updated every time it's played.

In Tweenput code, you can execute any defined Tween just by writing its name, no instruction name required. This way it will play the tween without waiting it to finish (like with `shrink` in the previous code). If we want to wait for the tween to play itself we can execute with the `WAIT` instruction (like with he `success` and `fail` tweens).

The `STOP` instruction just ends the `shrink` tween execution. Since it's after the `WTQE` instruction, which waits until the previous `QTE` detects something, this means that the sprite will stop shrinking right after the player has pressed the input (or after enough time has passed and the player didn't press anything).

This just leaves us to explain the `JMP` line. This instruction will jump to the `ok:` label (found some lines later in the code) if the condition given is met. 
In the condition we can see `res_qte[0] == 1`, where `res_qte` is an internal variable (always present) of type `Array[Int]` which stores the last QTE result of every channel (the index specifies the QTE channel). A result of `1` means the player pressed the input in time.
Again, more on results and channels of the QTE system here: [TimeWindow].

# Playing Twenput Code
Having both an interpreter ready, and our code ready, all that's left is to give the code to the interpreter and just play it.
In order to do this we can add another node and a GDScript to it. Something like this:
```
# example.gd

const CODE_PATH = "res://path/to/the/tweenput/code"
@onready var tweenterpreter: Tweenterpreter = $Tweenterpreter

func _ready() -> void:
	var file := FileAccess.open(CODE_PATH,FileAccess.READ);
	var text := file.get_as_text();
	tweenterpreter.process_code(text);
	tweenterpreter.set_variable("sprite",$Sprite2D);
	tweenterpreter.run()
```

See how we are including our sprite node in the interpreter. Since the Tweenput code uses the `sprite` variable (which doesn't exist internally) in its tweens, we define it externally. The code would push an error during execution otherwise.

Scene for this example:
```
Node2D (example.gd)
    Tweenterpreter
    Sprite2D
```
(Make sure to actually assign some sprite to the Sprite2D node)

# Next Steps
You should now be able to run the scene and interact with the Tweenput!

But this is just the basics, you can deep dive into other concepts and instructions in the [manual](/manual)!

[Tweenterpreter]: /class_reference/Tweenterpreter
[Instructions]: /manual#instruction_set
[TimeWindow]: /manual#time_window_system