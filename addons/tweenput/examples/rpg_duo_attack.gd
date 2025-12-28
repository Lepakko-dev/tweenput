extends Node2D

const CODE_PATH = "res://addons/tweenput/examples/rpg_duo_attack.txt"
@onready var tweenterpreter: Tweenterpreter = $Tweenterpreter

func _ready() -> void:
	var file := FileAccess.open(CODE_PATH,FileAccess.READ);
	var text := file.get_as_text();
	tweenterpreter.process_code(text);
	
	tweenterpreter.set_variable("ally1",$Character1);
	tweenterpreter.set_variable("ally2",$Character2);
	tweenterpreter.set_variable("enemy",$Enemy);
	tweenterpreter.set_variable("ball",%Ball);
	tweenterpreter.set_variable("path_ini_ball",$Character1/Path2D/PathFollow2D);
	tweenterpreter.run()
