extends Node

@onready var tin: TextEdit = $TIn
@onready var tout: TextEdit = $TOut
@onready var run_button: Button = $Button
@onready var interpreter: Tweenterpreter = $Tweenterpreter

func _ready() -> void:
	interpreter.parser.variables["target"] = $Target;
	
	interpreter.parser.error_out.use_label($RichTextLabel);
	tin.text_changed.connect(_refresh);
	run_button.pressed.connect(interpreter.run);
	_refresh()

func _refresh() -> void:
	tout.text = interpreter.process_code(tin.text);

func a():
	return;
