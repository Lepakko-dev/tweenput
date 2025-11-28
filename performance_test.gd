extends Node

var t:Tween;
var t2:Tween;
var t3:Tween;

var switch := false;

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		test();

func test():
	#t2 = create_tween();
	#t2.tween_interval(1);
	#t2.tween_callback(p.bind("first subtween"));
	#t2.stop();
	#
	#t3 = create_tween();
	#t3.tween_interval(0.5);
	#t3.tween_callback(p.bind("second subtween"));
	#t3.stop();
	
	# Works as expected
	#t = create_tween();
	#t.set_parallel();
	#t.tween_subtween(t2);
	#t.tween_subtween(t3);
	#t.set_parallel(false);
	#t.tween_callback(p.bind("End"))
	
	# Nope, doesn't work
	#t = create_tween();
	#t.set_loops(4);
	#t.tween_callback(branch);
	#t.tween_callback(p.bind("End"))

	# Nope, doesn't work. Can't make recursive sub-tween calls either
	#t2 = create_tween();
	#t2.tween_callback(p.bind("t2"));
	#t2.tween_callback(t.stop);
	#t2.tween_subtween(t);
	#t2.stop();
	#
	#t = create_tween();
	#t.tween_callback(p.bind("t"));
	#t.tween_callback(t2.stop);
	#t.tween_subtween(t2);
	
	await t.finished;

func p(i):
	print("-> ",i);


func branch():
	if switch:
		t2.play();
		await t2.finished;
	else:
		t3.play();
		await t3.finished;
	switch = !switch;
