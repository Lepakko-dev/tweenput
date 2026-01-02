class_name TweenputHelper
## This class solely exist because the Godot Engine doesn't support reflection
## on any [Variant] type that's not an [Object], 
## which means this has to be done manually.

#region Constructors
static func V2(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector2();
	if params.size() == 1: return Vector2(params[0].value());
	if params.size() == 2: return Vector2(params[0].value(), params[1].value());
	return null;
static func V2i(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector2i();
	if params.size() == 1: return Vector2i(params[0].value());
	if params.size() == 2: return Vector2i(params[0].value(), params[1].value());
	return null;

static func R2(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Rect2();
	if params.size() == 1: return Rect2(params[0].value());
	if params.size() == 2: return Rect2(params[0].value(), params[1].value());
	if params.size() == 4: return Rect2(params[0].value(), params[1].value(), params[2].value(), params[3].value());
	return null;
static func R2i(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Rect2i();
	if params.size() == 1: return Rect2i(params[0].value());
	if params.size() == 2: return Rect2i(params[0].value(), params[1].value());
	if params.size() == 4: return Rect2i(params[0].value(), params[1].value(), params[2].value(), params[3].value());
	return null;

static func V3(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector3();
	if params.size() == 1: return Vector3(params[0].value());
	if params.size() == 3: return Vector3(params[0].value(), params[1].value(), params[2].value());
	return null;
static func V3i(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector3i();
	if params.size() == 1: return Vector3i(params[0].value());
	if params.size() == 3: return Vector3i(params[0].value(), params[1].value(), params[2].value());
	return null;

static func R3(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return AABB();
	if params.size() == 1: return AABB(params[0].value());
	if params.size() == 2: return AABB(params[0].value(), params[1].value());
	return null;

static func C(params: Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Color();
	if params.size() == 1: return Color(params[0].value() as String);
	if params.size() == 3: return Color(params[0].value(), params[1].value(), params[2].value());
	if params.size() == 4: return Color(params[0].value(), params[1].value(), params[2].value(), params[3].value());
	return null;

static var constructors: Dictionary[String, Callable] = {
	"Vector2": V2,
	"Vector2i": V2i,
	"Rect2": R2,
	"Rect2i": R2i,
	"Vector3": V3,
	"Vector3i": V3i,
	"AABB": R3,
	"Color": C,
	# Implement more here if necessary.
};
#endregion
#region String
static var string_methods: Dictionary[String, Callable] = {
	"contains": _contains,
	"erase": _erase,
	"find": _find,
	"insert": _insert,
	"is_empty": _is_empty,
	"length": _length,
	"replace": _replace,
	"substr": _substr,
	"to_float": _to_float,
	"to_int": _to_int,
	"to_lower": _to_lower,
	"to_upper": _to_upper,
	"[]": _string_arr,
	"[]=": _string_arr_a,
};
static func _contains(ref: String, what: String) -> bool: return ref.contains(what);
static func _erase(ref: String, position: int, chars: int = 1) -> String: return ref.erase(position, chars);
static func _find(ref: String, what: String, from: int = 0) -> int: return ref.find(what, from);
static func _insert(ref: String, position: int, what: String) -> String: return ref.insert(position, what);
static func _is_empty(ref: String) -> bool: return ref.is_empty();
static func _length(ref: String) -> int: return ref.length();
static func _replace(ref: String, what: String, forwhat: String) -> String: return ref.replace(what, forwhat);
static func _substr(ref: String, from: int, length: int) -> String: return ref.substr(from, length);
static func _to_float(ref: String) -> float: return ref.to_float();
static func _to_int(ref: String) -> int: return ref.to_int();
static func _to_lower(ref: String) -> String: return ref.to_lower();
static func _to_upper(ref: String) -> String: return ref.to_upper();
static func _string_arr(ref: String, idx: int) -> String: return ref[idx];
static func _string_arr_a(ref: String, idx: int, value: String): ref[idx] = value;
#endregion
#region Vector2
static var vector2_methods: Dictionary[String, Callable] = {
	"angle_to_point": _vec2_angle_to_point,
	"[]": _vec2_arr,
	"[]=": _vec2_arr_a,
};
static func _vec2_angle_to_point(ref: Vector2, to: Vector2) -> float: return ref.angle_to_point(to);
static func _vec2_arr(ref: Vector2, idx: int) -> float: return ref[idx];
static func _vec2_arr_a(ref: Vector2, idx: int, val: float): ref[idx] = val;
#endregion
#region Vector2i
static var vector2i_methods: Dictionary[String, Callable] = {
	"[]": _vec2i_arr,
	"[]=": _vec2i_arr_a,
};
static func _vec2i_arr(ref: Vector2i, idx: int) -> int: return ref[idx];
static func _vec2i_arr_a(ref: Vector2i, idx: int, val: int): ref[idx] = val;
#endregion
#region Vector3
static var vector3_methods: Dictionary[String, Callable] = {
	"[]": _vec3_arr,
	"[]=": _vec3_arr_a,
};
static func _vec3_arr(ref: Vector3, idx: int) -> float: return ref[idx];
static func _vec3_arr_a(ref: Vector3, idx: int, val: float): ref[idx] = val;
#endregion
#region Vector3i
static var vector3i_methods: Dictionary[String, Callable] = {
	"[]": _vec3i_arr,
	"[]=": _vec3i_arr_a,
};
static func _vec3i_arr(ref: Vector3i, idx: int) -> int: return ref[idx];
static func _vec3i_arr_a(ref: Vector3i, idx: int, val: int): ref[idx] = val;
#endregion
#region Vector4
static var vector4_methods: Dictionary[String, Callable] = {
	"[]": _vec4_arr,
	"[]=": _vec4_arr_a,
};
static func _vec4_arr(ref: Vector4, idx: int) -> float: return ref[idx];
static func _vec4_arr_a(ref: Vector4, idx: int, val: float): ref[idx] = val;
#endregion
#region Vector4i
static var vector4i_methods: Dictionary[String, Callable] = {
	"[]": _vec4i_arr,
	"[]=": _vec4i_arr_a,
};
static func _vec4i_arr(ref: Vector4i, idx: int) -> int: return ref[idx];
static func _vec4i_arr_a(ref: Vector4i, idx: int, val: int): ref[idx] = val;
#endregion
#region Color
static var color_methods: Dictionary[String, Callable] = {
	"[]": _color_arr,
	"[]=": _color_arr_a,
};
static func _color_arr(ref: Color, idx: int) -> float: return ref[idx];
static func _color_arr_a(ref: Color, idx: int, val: float): ref[idx] = val;
#endregion
#region Callable
static var callable_methods: Dictionary[String, Callable] = {
	"bind": _bind,
	"bindv": _bindv,
	"call": _call,
	"callv": _callv,
	"get_argument_count": _get_arg_count,
	"is_null": _is_null,
	"is_valid": _is_valid,
	"unbound": _unbound,
};
static func _bind(ref: Callable, arg) -> Callable: return ref.bind(arg);
static func _bindv(ref: Callable, arg: Array) -> Callable: return ref.bindv(arg);
static func _call(ref: Callable, arg) -> Variant: return ref.call(arg);
static func _callv(ref: Callable, arg: Array) -> Variant: return ref.callv(arg);
static func _get_arg_count(ref: Callable) -> int: return ref.get_argument_count();
static func _is_null(ref: Callable) -> bool: return ref.is_null();
static func _is_valid(ref: Callable) -> bool: return ref.is_valid();
static func _unbound(ref: Callable, argcount: int) -> Callable: return ref.unbind(argcount);
#endregion
#region Array
static var array_methods: Dictionary[String, Callable] = {
	"append": _array_append,
	"back": _array_back,
	"clear": _array_clear,
	"erase": _array_erase,
	"find": _array_find,
	"font": _array_font,
	"has": _array_has,
	"insert": _array_insert,
	"is_empty": _array_is_empty,
	"pick_random": _array_pick_random,
	"pop_back": _array_pop_back,
	"pop_front": _array_pop_front,
	"remove_at": _array_remove_at,
	"resize": _array_resize,
	"shuffle": _array_shuffle,
	"size": _array_size,
	"[]": _array_arr,
	"[]=": _array_arr_a,
};
static func _array_append(ref: Array, val: Variant): ref.append(val);
static func _array_back(ref: Array) -> Variant: return ref.back();
static func _array_clear(ref: Array): ref.clear();
static func _array_erase(ref: Array, val: Variant): ref.erase(val);
static func _array_find(ref: Array, what: Variant, from: int = 0) -> int: return ref.find(what, from);
static func _array_font(ref: Array) -> Variant: return ref.front();
static func _array_has(ref: Array, val: Variant) -> bool: return ref.has(val);
static func _array_insert(ref: Array, pos: int, val: Variant) -> int: return ref.insert(pos, val);
static func _array_is_empty(ref: Array) -> bool: return ref.is_empty();
static func _array_pick_random(ref: Array) -> Variant: return ref.pick_random();
static func _array_pop_back(ref: Array) -> Variant: return ref.pop_back();
static func _array_pop_front(ref: Array) -> Variant: return ref.pop_front();
static func _array_remove_at(ref: Array, pos: int): ref.remove_at(pos);
static func _array_resize(ref: Array, size: int) -> int: return ref.resize(size);
static func _array_shuffle(ref: Array): ref.shuffle();
static func _array_size(ref: Array) -> int: return ref.size();
static func _array_arr(ref: Array, idx: int) -> Variant: return ref.get(idx);
static func _array_arr_a(ref: Array, idx: int, val: Variant): ref[idx] = val;
#endregion
#region Dictionary
static var dict_methods: Dictionary[String, Callable] = {
	"[]": _dict_arr,
	"[]=": _dict_arr_a,
};
static func _dict_arr(ref: Dictionary, idx: Variant) -> Variant: return ref.get(idx);
static func _dict_arr_a(ref: Dictionary, idx: Variant, val: Variant): ref[idx] = val;
#endregion
#region PackedArrays
static var byte_arr_methods: Dictionary[String, Callable] = {
	"[]": _pbyte_arr,
	"[]=": _pbyte_arr_a,
};
static func _pbyte_arr(ref: PackedByteArray, idx: int) -> int: return ref.get(idx);
static func _pbyte_arr_a(ref: PackedByteArray, idx: int, val: int): ref.set(idx, val);

static var int32_arr_methods: Dictionary[String, Callable] = {
	"[]": _pint32_arr,
	"[]=": _pint32_arr_a,
};
static func _pint32_arr(ref: PackedInt32Array, idx: int) -> int: return ref.get(idx);
static func _pint32_arr_a(ref: PackedInt32Array, idx: int, val: int): ref.set(idx, val);

static var int64_arr_methods: Dictionary[String, Callable] = {
	"[]": _pint64_arr,
	"[]=": _pint64_arr_a,
};
static func _pint64_arr(ref: PackedInt64Array, idx: int) -> int: return ref.get(idx);
static func _pint64_arr_a(ref: PackedInt64Array, idx: int, val: int): ref.set(idx, val);

static var float32_arr_methods: Dictionary[String, Callable] = {
	"[]": _pfloat32_arr,
	"[]=": _pfloat32_arr_a,
};
static func _pfloat32_arr(ref: PackedFloat32Array, idx: int) -> float: return ref.get(idx);
static func _pfloat32_arr_a(ref: PackedFloat32Array, idx: int, val: float): ref.set(idx, val);

static var float64_arr_methods: Dictionary[String, Callable] = {
	"[]": _pfloat64_arr,
	"[]=": _pfloat64_arr_a,
};
static func _pfloat64_arr(ref: PackedFloat64Array, idx: int) -> float: return ref.get(idx);
static func _pfloat64_arr_a(ref: PackedFloat64Array, idx: int, val: float): ref.set(idx, val);

static var string_arr_methods: Dictionary[String, Callable] = {
	"[]": _pstring_arr,
	"[]=": _pstring_arr_a,
};
static func _pstring_arr(ref: PackedStringArray, idx: int) -> String: return ref.get(idx);
static func _pstring_arr_a(ref: PackedStringArray, idx: int, val: String): ref.set(idx, val);

static var vector2_arr_methods: Dictionary[String, Callable] = {
	"[]": _pv2_arr,
	"[]=": _pv2_arr_a,
};
static func _pv2_arr(ref: PackedVector2Array, idx: int) -> Vector2: return ref.get(idx);
static func _pv2_arr_a(ref: PackedVector2Array, idx: int, val: Vector2): ref.set(idx, val);

static var vector3_arr_methods: Dictionary[String, Callable] = {
	"[]": _pv3_arr,
	"[]=": _pv3_arr_a,
};
static func _pv3_arr(ref: PackedVector3Array, idx: int) -> Vector3: return ref.get(idx);
static func _pv3_arr_a(ref: PackedVector3Array, idx: int, val: Vector3): ref.set(idx, val);

static var color_arr_methods: Dictionary[String, Callable] = {
	"[]": _pcolor_arr,
	"[]=": _pcolor_arr_a,
};
static func _pcolor_arr(ref: PackedColorArray, idx: int) -> Color: return ref.get(idx);
static func _pcolor_arr_a(ref: PackedColorArray, idx: int, val: Color): ref.set(idx, val);


static var vector4_arr_methods: Dictionary[String, Callable] = {
	"[]": _pv4_arr,
	"[]=": _pv4_arr_a,
};
static func _pv4_arr(ref: PackedVector4Array, idx: int) -> Vector4: return ref.get(idx);
static func _pv4_arr_a(ref: PackedVector4Array, idx: int, val: Vector4): ref.set(idx, val);
#endregion

static var variants: Array[Dictionary] = [ # All 38 types of Variant ordered by Variant.TYPE
	{}, {}, {}, {}, string_methods,
	vector2_methods, vector2i_methods, {}, {}, vector3_methods,
	vector3i_methods, {}, vector4_methods, vector4i_methods, {},
	{}, {}, {}, {}, {},
	color_methods, {}, {}, {}, {},
	callable_methods, {}, dict_methods, array_methods, byte_arr_methods,
	int32_arr_methods, int64_arr_methods, float32_arr_methods, float64_arr_methods, string_arr_methods,
	vector2_arr_methods, vector3_arr_methods, color_arr_methods, vector4_arr_methods
]

#region MACROS
static var macros: Dictionary[String, String] = {
	"TWEEN_PROCESS_PHYSICS": "0",
	"TWEEN_PROCESS_IDLE": "1",
	
	"TWEEN_PAUSE_BOUND": "0",
	"TWEEN_PAUSE_STOP": "1",
	
	"TRANS_LINEAR": "0",
	"TRANS_SINE": "1",
	"TRANS_QUINT": "2",
	"TRANS_QUART": "3",
	"TRANS_QUAD": "4",
	"TRANS_EXPO": "5",
	"TRANS_ELASTIC": "6",
	"TRANS_CUBIC": "7",
	"TRANS_CIRC": "8",
	"TRANS_BOUNCE": "9",
	"TRANS_BACK": "10",
	"TRANS_SPRING": "11",

	"EASE_IN": "0",
	"EASE_OUT": "1",
	"EASE_IN_OUT": "2",
	"EASE_OUT_IN": "3",
};
#endregion

static func construct(type: String) -> Callable:
	return constructors.get(type, Callable());

static func reflect(obj: Variant, method: String) -> Callable:
	var t := typeof(obj);
	var dir: Dictionary = variants.get(t);
	return dir.get(method, Callable());

static func get_macro(macro: String) -> String:
	return macros.get(macro, "");