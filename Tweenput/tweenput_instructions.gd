class_name TweenputInstructions

static var instructions : Dictionary[String,Callable] = {
	"SET":SET,
	"SWAP":SWAP,
	# Flow of Execution Related
	"EMIT":_dummy,
	"WAIT":_dummy,
	"JMP":_dummy,
	"CALL":_dummy,
	"RET":_dummy,
	"LINK":_dummy,
	"UNLINK":_dummy,
	"END":END,
	# Other Animation Related
	"QTE":_dummy,
	"WQTE":_dummy,
	"ANIMATE":_dummy,
	"WANIMATE":_dummy,
};

static func _dummy():
	print("Dummy instruction executed.");

static func SET(id:TweenputParser.LangNode,expr:TweenputParser.LangNode):
	if id is not TweenputParser.LIdentifier: 
		push_error("Tweenput: SET -> 1º param not a variable");
		return;
	var var_name : String = id._name;
	var value = expr.value();
	print("SET %s , %s"%[var_name,value]);

static func SWAP(a:TweenputParser.LangNode,b:TweenputParser.LangNode):
	if a is not TweenputParser.LIdentifier:
		push_error("Tweenput: SET -> 1º param not a variable");
		return;
	if b is not TweenputParser.LIdentifier:
		push_error("Tweenput: SET -> 2º param not a variable");
		return;
	var a_name : String = a._name;
	var b_name : String = b._name;
	print("SWAP %s , %s"%[a_name,b_name]);

static func END():
	print("END");

#region Extras
#region Constructors
static func V2 (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector2();
	if params.size() == 1: return Vector2(params[0].value());
	if params.size() == 2: return Vector2(params[0].value(),params[1].value());
	return null;
static func V2i (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector2i();
	if params.size() == 1: return Vector2i(params[0].value());
	if params.size() == 2: return Vector2i(params[0].value(),params[1].value());
	return null;

static func R2 (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Rect2();
	if params.size() == 1: return Rect2(params[0].value());
	if params.size() == 2: return Rect2(params[0].value(),params[1].value());
	if params.size() == 4: return Rect2(params[0].value(),params[1].value(),params[2].value(),params[3].value());
	return null;
static func R2i (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Rect2i();
	if params.size() == 1: return Rect2i(params[0].value());
	if params.size() == 2: return Rect2i(params[0].value(),params[1].value());
	if params.size() == 4: return Rect2i(params[0].value(),params[1].value(),params[2].value(),params[3].value());
	return null;

static func V3 (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector3();
	if params.size() == 1: return Vector3(params[0].value());
	if params.size() == 3: return Vector3(params[0].value(),params[1].value(),params[2].value());
	return null;
static func V3i (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return Vector3i();
	if params.size() == 1: return Vector3i(params[0].value());
	if params.size() == 3: return Vector3i(params[0].value(),params[1].value(),params[2].value());
	return null;

static func R3 (params : Array[TweenputParser.LangNode]) -> Variant:
	if params.size() == 0: return AABB();
	if params.size() == 1: return AABB(params[0].value());
	if params.size() == 2: return AABB(params[0].value(),params[1].value());
	return null;

static var constructors : Dictionary[String,Callable] = {
	"Vector2": V2,
	"Vector2i": V2i,
	"Rect2": R2,
	"Rect2i": R2i,
	"Vector3": V3,
	"Vector3i": V3i,
	"AABB":R3,
	# Implement more here if necessary.
};
#endregion
#region String
static var string_methods : Dictionary[String,Callable] = {
	"contains":_contains,
	"erase":_erase,
	"find":_find,
	"insert":_insert,
	"is_empty":_is_empty,
	"length":_length,
	"replace":_replace,
	"substr":_substr,
	"to_float":_to_float,
	"to_int":_to_int,
	"to_lower":_to_lower,
	"to_upper":_to_upper,
};
static func _contains(ref:String, what:String)-> bool: return ref.contains(what);
static func _erase(ref:String, position:int,chars:int=1)-> String: return ref.erase(position,chars);
static func _find(ref:String, what:String,from:int=0)-> int: return ref.find(what,from);
static func _insert(ref:String, position:int,what:String)-> String: return ref.insert(position,what);
static func _is_empty(ref:String)-> bool: return ref.is_empty();
static func _length(ref:String)-> int: return ref.length();
static func _replace(ref:String, what:String, forwhat:String)-> String: return ref.replace(what,forwhat);
static func _substr(ref:String, from:int, length:int) -> String: return ref.substr(from,length);
static func _to_float(ref:String)-> float: return ref.to_float();
static func _to_int(ref:String)-> int: return ref.to_int();
static func _to_lower(ref:String)-> String: return ref.to_lower();
static func _to_upper(ref:String)-> String: return ref.to_upper();
#endregion
#region Callable
static var callable_methods : Dictionary[String,Callable] = {
	"bind":_bind,
	"bindv":_bindv,
	"call":_call,
	"callv":_callv,
	"get_argument_count":_get_arg_count,
	"is_null":_is_null,
	"is_valid":_is_valid,
	"unbound":_unbound,
};
static func _bind(ref:Callable, arg) -> Callable: return ref.bind(arg);
static func _bindv(ref:Callable, arg:Array) -> Callable: return ref.bindv(arg);
static func _call(ref:Callable, arg) -> Variant: return ref.call(arg);
static func _callv(ref:Callable, arg:Array) -> Variant: return ref.callv(arg);
static func _get_arg_count(ref:Callable) -> int: return ref.get_argument_count();
static func _is_null(ref:Callable) -> bool: return ref.is_null();
static func _is_valid(ref:Callable) -> bool: return ref.is_valid();
static func _unbound(ref:Callable,argcount:int) -> Callable: return ref.unbind(argcount);
#endregion

static func construct(type:String) -> Callable:
	return constructors.get(type,null);

static func reflect(obj:Variant, method:String) -> Callable:
	var t := typeof(obj);
	var dir : Dictionary = variants.get(t);
	return dir.get(method,Callable());

static var variants : Array[Dictionary] = [ # All 38 types of Variant ordered by Variant.TYPE
	{},{},{},{},string_methods, {},{},{},{},{},
	{},{},{},{},{}, {},{},{},{},{},
	{},{},{},{},{}, callable_methods,{},{},{},{},
	{},{},{},{},{}, {},{},{},{}
]
#endregion
