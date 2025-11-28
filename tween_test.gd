extends Node

var i := 0;

var t : Tween

func _ready() -> void:
	t = create_tween();
	await t.tween_interval(2).finished;
	t.tween_interval(2);

func _process(_delta: float) -> void:
	print(t);

func foo():
	print(i);
	i += 1;

func pfoo():
	print(i," (parallel)");
	i += 1;
