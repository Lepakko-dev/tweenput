extends RefCounted
class_name TweenputErrorHandler

var _out : Callable;
var _label : RichTextLabel;

var _skip:bool;

func _init() -> void:
	_out = _send_to_console;

func enable(value:bool=true):
	_skip = not value;

func use_label(target:RichTextLabel = null) -> void:
	if target: _out = _send_to_label;
	else: _out = _send_to_console;
	_label = target;

func clear_label() -> void:
	_label.clear();

func error(msg:String) -> void:
	if _skip: return;
	_out.call(msg);

func warn(msg:String) -> void:
	if _skip: return;
	_out.call(msg);

func _send_to_console(msg:String,danger:bool=true):
	if danger: printerr(msg);
	else: print_rich("[color=yellow]"+msg);

func _send_to_label(msg:String,danger:bool=true):
	if _label:
		if danger: _label.push_color(Color(0.79, 0.182, 0.324, 1.0));
		else: _label.push_color(Color(0.871, 0.506, 0.302, 1.0));
		_label.append_text(msg+" ");
