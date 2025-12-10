extends RefCounted
class_name TweenputLogger

var _out: Callable;
var _label: RichTextLabel;

var _skip: bool;

enum DangerLevel {NONE = 0, WARN = 1, ERROR = 2};


func _init() -> void:
	_out = _send_to_console;


func enable(value: bool = true):
	_skip = not value;


func use_label(target: RichTextLabel = null) -> void:
	if target: _out = _send_to_label;
	else: _out = _send_to_console;
	_label = target;


func clear_label() -> void:
	_label.clear();


func err(msg: String) -> void:
	if _skip: return ;
	_out.call(msg, DangerLevel.ERROR);


func warn(msg: String) -> void:
	if _skip: return ;
	_out.call(msg, DangerLevel.WARN);


func p_log(msg: String) -> void:
	if _skip: return ;
	_out.call(msg, DangerLevel.NONE);


func _send_to_console(msg: String, danger: DangerLevel = DangerLevel.NONE):
	if danger == DangerLevel.ERROR:
		printerr(msg);
	elif danger == DangerLevel.WARN:
		print_rich("[color=yellow]" + msg);
	else:
		print(msg);


func _send_to_label(msg: String, danger: DangerLevel = DangerLevel.NONE):
	if _label:
		if danger == DangerLevel.ERROR:
			_label.push_color(Color(0.79, 0.182, 0.324, 1.0));
		elif danger == DangerLevel.WARN:
			_label.push_color(Color(0.871, 0.506, 0.302, 1.0));
		_label.append_text(msg + " ");
		if danger != DangerLevel.NONE:
			_label.pop();
