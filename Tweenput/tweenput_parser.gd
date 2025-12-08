extends Node
class_name TweenputParser
## Parses a text following the Tweenput grammar and turns it into an executable AST

#region Grammar
# Most lookarounds are there to avoid conflict with our language collapser or grammar rules.
const STRING =	r'"(?<val>(?:[^"\n]|(?:\\"))*)"'
const CONST =	r"(?<![A-Za-z_#]{1,9}\d{0,9})(?:(?<bin>0b(?:[0-1])+)|(?<hex>0x(?:\d|[a-f])+)|(?<dec>\d+(?:\.\d*)?))"
const ID =		r"(?<obj>[a-zA-Z_]\w*)"

const MEMBR_ACCESS_EXPR = r"(?<parent>#\d+)\.(?<member>#\d+)"; # Operands must be ID.
const UNARY_EXPR =	r"(?<=-|\D|^)"+SEP+r"(?<op>\+|-|~|!)+"+SEP+r"(?<v1>#\d+)"
const MUL_EXPR =	r"(?<v1>#\d+)"+SEP+r"(?<op>\*|\/)"+SEP+r"(?<v2>#\d+)"
const ADD_EXPR =	r"(?<v1>#\d+)"+SEP+r"(?<op>\+|-)"+SEP+r"(?<v2>#\d+)"
const SHIFT_EXPR =	r"(?<v1>#\d+)"+SEP+r"(?<op>>>|<<)"+SEP+r"(?<v2>#\d+)"

const REL_EXPR =	r"(?<v1>#\d+)"+SEP+r"(?<op>>|<|>=|<=)"+SEP+r"(?<v2>#\d+)"
const EQ_EXPR =		r"(?<v1>#\d+)"+SEP+r"(?<op>==|!=)"+SEP+r"(?<v2>#\d+)"

const AND_EXPR =	r"(?<v1>#\d+)"+SEP+r"&"+SEP+r"(?<v2>#\d+)"
const XOR_EXPR =	r"(?<v1>#\d+)"+SEP+r"\^"+SEP+r"(?<v2>#\d+)"
const OR_EXPR =		r"(?<v1>#\d+)"+SEP+r"\|"+SEP+r"(?<v2>#\d+)"

const LOGIC_AND_EXPR =	r"(?<v1>#\d+)"+SEP+r"&&"+SEP+r"(?<v2>#\d+)"
const LOGIC_OR_EXPR =	r"(?<v1>#\d+)"+SEP+r"\|\|"+SEP+r"(?<v2>#\d+)"

const INSTR =		LOOKBREAK+r"(?<instr>[a-zA-Z_]\w*)"+SEP+r"(?:"+H+r"(?<params>[^\n;:{]+))?(?:[\n;]+|$)"
const LABEL =		LOOKBREAK+r"(?<label>[a-zA-Z_]\w*):(?:[^\S]*)(?<node>#\d+)"
const TWEEN_DEF =	LOOKBREAK+r"("+ID+r"[^\S\n]*\{(?<list>(?:[\n;]*\s*(?:[^\n;}]+)?)*)?\})";
const TWEEN_EXE =	LOOKBREAK+r"(?<tween>[a-zA-Z_]\w*)"

const LINE =		"("+INSTR+"|"+TWEEN_DEF+"|"+LABEL+"|"+TWEEN_EXE+")"
const S = 			"^"+LINE+"("+BREAK+LINE+")*"+BREAK+"?$"

const H =		r"(?:[^\S\n])"
const SEP =		r"(?:[^\S\n]*)"
const BREAK =	r"(?:(?:\n|;|^)\s*)"
const LOOKBREAK = r"(?<=(?:\n|;|^)\s{0,99})"
const COMMENT = r'(?<!(\n|^)[^"]{0,99}"[^"]{0,99})#[^\n]*' # Huge lookbehind to not take comments inside string literals
const CNODE = 	r"(?<id>#\d+)";

var _rconst := RegEx.new();
var _rstring := RegEx.new();
var _rid := RegEx.new();
var _rma := RegEx.new();

var _runa := RegEx.new();
var _rmul := RegEx.new();
var _radd := RegEx.new();
var _rshf := RegEx.new();

var _rrel := RegEx.new();
var _req := RegEx.new();

var _rand := RegEx.new();
var _rxor := RegEx.new();
var _ror := RegEx.new();

var _randl := RegEx.new();
var _rorl := RegEx.new();

var _rinstr := RegEx.new();
var _rtween := RegEx.new();
var _rtexe := RegEx.new();
var _rlabel := RegEx.new();
var _rline := RegEx.new();
var _rbreak := RegEx.new();
var _rs := RegEx.new();

var _rcomment = RegEx.new();

var _rnode := RegEx.new();
var _rid_aux := RegEx.new();

func _compile_regex():
	_rconst.compile(CONST);
	_rstring.compile(STRING);
	_rid.compile(ID);
	
	_rma.compile(MEMBR_ACCESS_EXPR);
	
	_runa.compile(UNARY_EXPR);
	_rmul.compile(MUL_EXPR);
	_radd.compile(ADD_EXPR);
	_rshf.compile(SHIFT_EXPR);
	
	_rrel.compile(REL_EXPR);
	_req.compile(EQ_EXPR);
	
	_rand.compile(AND_EXPR);
	_rxor.compile(XOR_EXPR);
	_ror.compile(OR_EXPR);
	
	_randl.compile(LOGIC_AND_EXPR);
	_rorl.compile(LOGIC_OR_EXPR);
	
	_rinstr.compile(INSTR);
	_rtween.compile(TWEEN_DEF);
	_rtexe.compile(TWEEN_EXE);
	_rlabel.compile(LABEL);
	_rline.compile(LINE);
	_rbreak.compile(BREAK);
	_rs.compile(S);
	
	_rcomment.compile(COMMENT);
	
	_rnode.compile(CNODE);
	_rid_aux.compile(CNODE+r"(?<op>\(|\[)");
#endregion

## Instructions valid inside a Tween definition only.
const tween_instrunctions : Dictionary[String,String] = {
	"BIND":"bind_node",
	"INTERVAL":"tween_interval",
	"CALLBACK":"tween_callback",
	"METHOD":"tween_method",
	"PROPERTY":"tween_property",
	"SUBTWEEN":"tween_subtween",
	"PARALLEL":"set_parallel",
	"EASE":"set_ease",
	"IGNORE_TIME_SCALE":"set_ignore_time_scale",
	"PAUSE_MODE":"set_pause_mode",
	"PROCESS_MODE":"set_process_mode",
	"SPEED_SCALE":"set_speed_scale",
	"TRANS":"set_trans",
};

## A list of all implemented instructions for a the represented language.
## Set these from external sources.
@export var instructions : Dictionary[String,Callable] = {};

#region AST Classes
@abstract class LangNode:
	var node_name : String;
	@abstract func value() -> Variant;

class LInstr extends LangNode:
	var next : LInstr;
	var _params : Array[LangNode];
	var _cached_instr : Callable;
	func _init(name:String,params:Array[LangNode],parser:TweenputParser) -> void:
		node_name = name.to_upper();
		_params = params;
		_cached_instr = parser.instructions.get(node_name,Callable());
		var required_param_count := _cached_instr.get_argument_count();
		if params.size() > required_param_count:
			parser.error_out.error("Bad argument count. Instruction %s needs %d arguments. %d were given."%
				[name,required_param_count,params.size()]);
		if _cached_instr.is_null():
			if node_name in parser.tween_instrunctions:
				parser.error_out.error("Tween Instructions cannot be outside a Tween definition (%s)"%name);
			else:
				parser.error_out.error("Bad instruction name (%s)"%name);
	func value() -> Variant:
		return _cached_instr;
	func execute() -> Callable: return _cached_instr.bindv(_params);

class LInstrTween extends LInstr:
	# Doesn't need to use 'next' var since order is handled by LTweenDef class
	var _m_name : String;
	var _parser:TweenputParser
	func _init(name:String,params:Array[LangNode],parser:TweenputParser):
		node_name = name.to_upper();
		_params = params;
		_parser = parser;
		_m_name = parser.tween_instrunctions.get(node_name,"");
		if _m_name.is_empty():
			parser.error_out.error("Bad instruction name (%s)"%name);
			return;
		elif node_name in parser.instructions:
			parser.error_out.error("Regular Instructions cannot be inside a Tween definition (%s)"%name);
			
	func execute() -> Callable:
		if _cached_instr.get_object() != _parser.current_building_tween:
			_cached_instr = _parser.current_building_tween.call;
		var correct_arg_count := _parser.current_building_tween.get_method_argument_count(_m_name);
		if correct_arg_count != _params.size():
			_parser.error_out.error("Incorrect argument count for %s (%d) should be %d"%
				[node_name,_params.size(),correct_arg_count]);
			return Callable();
		
		var updated_params : Array[Variant] = [_m_name];
		for p in _params:
			updated_params.append(p.value());
		var res := _cached_instr.bindv(updated_params);
		res.call();
		return res.call;

class LString extends LangNode:
	var _literal : String;
	func _init(string:String):
		_literal = string;
	func value() -> Variant:
		return _literal;

class LConst extends LangNode:
	var _val : Variant;
	func _init(number:Variant):
		_val = number
	func value() -> Variant:
		return _val;

class LConstArray extends LangNode:
	var _elems : Array[LangNode];
	func _init(elems:Array[LangNode]) -> void:
		_elems = elems;
	func value() -> Variant:
		var array = [];
		for elem in _elems:
			if elem:
				array.append(elem.value());
		return array;

class LTweenDef extends LangNode:
	var _instr_list : Array[LInstrTween];
	var _parser : TweenputParser;
	func _init(name:String, instr_list:Array[LInstrTween], parser:TweenputParser):
		node_name = name;
		_instr_list = instr_list;
		_parser = parser;
	func value() -> Variant:
		return node_name;
	func execute() -> void:
		_parser.current_building_tween = _parser.create_tween();
		for instr in _instr_list:
			instr.execute();
		_parser.variables[node_name] = _parser.current_building_tween;
		_parser.current_building_tween = null;

class LTweenExe extends LInstr:
	var _parser : TweenputParser;
	var tween : Tween;
	func _init(tween_id:String,parser:TweenputParser) -> void:
		node_name = tween_id;
		_parser = parser;
		var builder : LTweenDef = _parser._tween_map.get(node_name,null);
		if builder: _cached_instr = builder.execute;
	func value() -> Variant:
		return node_name;
	func execute() -> Callable:
		if _cached_instr: # Has a tween definition to update the tween.
			_cached_instr.call();
			tween = _parser.variables.get(node_name,null) as Tween;
		else: # Is a tween variable set outside of Tweenput code.
			var aux = _parser.variables.get(node_name,null);
			if not aux or aux is not Tween:
				_parser.error_out.error("Variable %s is not a Tween"%node_name);
				return Callable();
			tween = aux as Tween;
		tween.stop();
		return tween.play;

## Groups all nodes that handle variable data 
## (to group nodes usually checked together in instructions)
@abstract class LVar extends LangNode:
	## Stores the parent reference (necessary due to de-reference working in opposite order)
	var ref_ctx : Variant;

class LIdentifier extends LVar:
	var _parser : TweenputParser;
	func _init(name:Variant, parser : TweenputParser):
		node_name = name;
		_parser = parser;
	func value() -> Variant:
		if ref_ctx != null:
			if ref_ctx is Object:
				return ref_ctx.get(node_name);
			else:
				_parser.error_out.error("Variable must belong to an object of type Object.");
				return null;
		else:
			return _parser.variables.get(node_name);

@abstract class LBinOp extends LVar:
	var a : LangNode;
	var b : LangNode;
	func _init(left_var: LangNode, right_var:LangNode):
		a = left_var; 
		b = right_var;

class LDeReference extends LBinOp: # '.' operator
	var _parser: TweenputParser;
	func _init(left_var: LangNode, right_var:LangNode, parser:TweenputParser):
		super(left_var,right_var);
		_parser = parser;
		if a is not LVar:
			parser.error_out.error("Trying to access method or variable from invalid node.")
		if b is not LVar:
			parser.error_out.error("Trying to access an invalid method or variable node.");
		node_name = "%s.%s"%[a.node_name,b.node_name];
	
	## Returns the recursively de-referenced value of the operation.
	func value() -> Variant:
		var aux : Variant;
		if ref_ctx != null: aux = ref_ctx;
		else: aux = a.value();
		
		if b is LVar:
			b.ref_ctx = aux;
			return b.value();
		else:
			_parser.error_out.error("Trying to access an invalid method or variable node.");
		return null;

class LMethodCall extends LVar: # Call to godot methods "method(params)".
	var _node : LVar;
	var _params : Array[LangNode];
	var _parser : TweenputParser;
	var _cached_instr : Callable;
	func _init(id:String, params:Array[LangNode], parser:TweenputParser):
		node_name = id;
		_params = params;
		_parser = parser;
		_node = parser._collapse_map.get(id);
		if not _node:
			parser.error_out.error("Operator [] is trying to access an unknown node (%s)."%id);
			return;
		_cached_instr = TweenputHelper.construct(_node.node_name);
	func value() -> Variant:
		var method_name := _node.node_name;
		if ref_ctx != null: # Method from an object
			if ref_ctx is Object: # Can use reflection
				if not ref_ctx.has_method(method_name):
					_parser.error_out.error("Invalid method '%s' of object '%s'"%[method_name,ref_ctx]);
					return null;
				var updated_params : Array;
				for p in _params: updated_params.append(p.value());
				return ref_ctx.call(method_name,updated_params);
			else: # Another type of variant (Manual Reflection)
				var method := TweenputHelper.reflect(ref_ctx,method_name);
				if method.is_valid():
					var updated_params : Array;
					for p in _params: 
						if p:
							updated_params.append(p.value());
					return method.bindv(updated_params).call(ref_ctx);
				else:
					_parser.error_out.error("Invalid method or not implemented (%s)"%method_name);
			return null;
		else: #Standalone method (Constructors, etc)
			if not _cached_instr.is_valid(): 
				_parser.error_out.error("Unknown constuctor (%s)"%method_name);
			return _cached_instr.call(_params);

class LArrayAccess extends LVar: # var[index]
	var _node : LVar;
	var _idx : LangNode;
	var _parser : TweenputParser;
	func _init(id:String, idx:LangNode, parser:TweenputParser):
		node_name = id;
		_idx = idx;
		_parser = parser;
		_node = parser._collapse_map.get(id);
		if not _node:
			parser.error_out.error("Operator [] is trying to access an unknown node (%s)."%id);
	func value() -> Variant:
		var idx = _idx.value();
		var container:Variant;
		var method : Callable;
		var container_name := _node.node_name;
		if ref_ctx != null: # Container is member of some object
			if ref_ctx is Object:
				if _node is LIdentifier: container = ref_ctx.get(container_name);
				else: container = null;
			else: # Need to manually reflect
				container = TweenputHelper.reflect(ref_ctx,container_name).call();
		else: # Container is a true variable (managed by the parser)
			container = _parser.variables.get(container_name);
		
		method = TweenputHelper.reflect(container,"[]");
		if method.is_valid():
			return method.call(container,idx);
		else:
			_parser.error_out.error("Variable '%s' can't use the [] operator."%container_name);
			return null;

@abstract class LUnary extends LVar:
	var node : LangNode;
	func _init(e: LangNode): node = e;

class LPlus extends LUnary: func value() -> Variant: return node.value();
class LMinus extends LUnary: func value() -> Variant: return -node.value();
class LNotLogic extends LUnary: func value() -> Variant: return !node.value();
class LNotBit extends LUnary: func value() -> Variant: return ~node.value();

class LMul extends LBinOp: func value() -> Variant: return a.value() * b.value();
class LDiv extends LBinOp: func value() -> Variant: return a.value() / b.value();
class LAdd extends LBinOp: func value() -> Variant: return a.value() + b.value();
class LSub extends LBinOp: func value() -> Variant: return a.value() - b.value();
class LShiftL extends LBinOp: func value() -> Variant: return a.value() << b.value();
class LShiftR extends LBinOp: func value() -> Variant: return a.value() >> b.value();
class LGT extends LBinOp: func value() -> Variant: return a.value() > b.value();
class LLT extends LBinOp: func value() -> Variant: return a.value() < b.value();
class LGE extends LBinOp: func value() -> Variant: return a.value() >= b.value();
class LLE extends LBinOp: func value() -> Variant: return a.value() <= b.value();
class LEQ extends LBinOp: func value() -> Variant: return a.value() == b.value();
class LNEQ extends LBinOp: func value() -> Variant: return a.value() != b.value();
class LAnd extends LBinOp: func value() -> Variant: return a.value() & b.value();
class LXor extends LBinOp: func value() -> Variant: return a.value() ^ b.value();
class LOr extends LBinOp: func value() -> Variant: return a.value() | b.value();
class LAndL extends LBinOp: func value() -> Variant: return a.value() && b.value();
class LOrL extends LBinOp: func value() -> Variant: return a.value() || b.value();

#endregion

# Variables generated at EXECUTION time
## Maps variable names with its value.
@export var variables: Dictionary[String,Variant] = {};

## Auxiliar variable to hold a reference to a tween during its building phase in a tween definition.
var current_building_tween : Tween;

# Varaibles generated at COMPILE time (but used during execution)
## The first Language Node in code.
var root_node : LInstr;
## Maps all labels to the instruction they point to.
var label_map : Dictionary[String,LInstr];
## Holds all tween definitions so executed tweens can rebuild themselves at execution time.
var _tween_map : Dictionary[String,LTweenDef];

# Variables used at COMPILE time only
## Holds the translations of certain syntax to an identifier when collapsed.
var _collapse_map : Dictionary[String,LangNode] = {};
## Counter to make collapsed nodes have an unique identifier.
var _counter := 0;

var error_out : TweenputErrorHandler;


func _init():
	_compile_regex()
	error_out = TweenputErrorHandler.new();

func parse(text:String) -> String:
	if instructions.is_empty(): 
		push_error("""Tweenput Parser is being used with no instruction set. 
		Use the parser with a Tweenterpreter or your own implementation instead.""");
		return "";
	
	error_out.clear_label();
	root_node = null;
	label_map.clear();
	_tween_map.clear();
	_collapse_map.clear();
	_counter = 0;
	
	if not text.ends_with("\n"): text += "\n";
	
	# Main parsing steps (order is crucial)
	text = _remove_comments(text);
	text = _collapse_literals(text); #(numbers and strings)
	text = _collapse_tween_defs(text);
	text = _collapse_instr(text);
	text = _collapse_labels(text);
	
	_join_instructions(text);
	return text


func _remove_comments(text:String) -> String:
	var comment_match := _rcomment.search(text);
	while comment_match:
		var i := comment_match.get_start();
		var l := comment_match.get_end() - i;
		text = text.erase(i,l);
		comment_match = _rcomment.search(text,i);
	return text;

## Easy One Off Values (literals)
func _collapse_literals(text:String) -> String:
	var string := _rstring.search(text);
	while string:
		var key := _make_node_id();
		var val := string.get_string("val");
		_collapse_map[key] = LString.new(val);
		var idx := string.get_start();
		var full := string.get_string();
		text = text.erase(idx,full.length()).insert(idx,key);
		string = _rstring.search(text);
		
	var const_ := _rconst.search(text);
	while const_:
		var key := _make_node_id();
		var val := const_.get_string();
		if not const_.get_string("bin").is_empty():
			_collapse_map[key] = LConst.new(val.bin_to_int());
		elif not const_.get_string("hex").is_empty():
			_collapse_map[key] = LConst.new(val.hex_to_int());
		elif not const_.get_string("dec").is_empty():
			if val.contains('.'):
				_collapse_map[key] = LConst.new(val.to_float());
			else:
				_collapse_map[key] = LConst.new(val.to_int());
		var idx := const_.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);
		const_ = _rconst.search(text);
	return text;

## Stores Label references and collapses them
func _collapse_labels(text:String) -> String:
	var label := _rlabel.search(text);
	while label:
		var i := label.get_start();
		var l := label.get_end() - i;
		var label_name := label.get_string("label");
		var node_id := label.get_string("node");
		label_map[label_name] = _collapse_map[node_id] as LInstr;
		text = text.erase(i,l).insert(i,node_id);
		label = _rlabel.search(text,i);
	return text;

func _collapse_tween_defs(text:String) -> String:
	var def := _rtween.search(text);
	while def:
		var instr_string := def.get_string("list");
		var instr_list : Array[LInstrTween];
		_collapse_t_instr(instr_string,instr_list);
		# TODO wanr the user for unwanted text instead of ignoring it (like uncollapsed labels)
		
		var key := _make_node_id()
		var ini := def.get_start();
		var end := def.get_end();
		text = text.erase(ini,end-ini).insert(ini,key);
		var tween_name := def.get_string("obj");
		var builder_node := LTweenDef.new(tween_name,instr_list,self);
		_collapse_map[key] = builder_node
		_tween_map[tween_name] = builder_node;
		def = _rtween.search(text);
	return text

## Groups all tween instructions of a tween definition
func _collapse_t_instr(text:String, list:Array[LInstrTween]) -> String:	
	var instr := _rinstr.search(text);
	while instr:
		var key := _make_node_id();
		var full := instr.get_string();
		var instr_name := instr.get_string("instr");
		var params := instr.get_string("params");
		
		var nodes := _collapse_params(params);
		var lit := LInstrTween.new(instr_name,nodes,self);
		list.append(lit);
		_collapse_map[key] = lit;
		var idx := instr.get_start();
		text = text.erase(idx,full.length()).insert(idx,key+"\n");
		instr = _rinstr.search(text);
	return text;

## Instruction separation
func _collapse_instr(text:String) -> String:	
	var instr := _rinstr.search(text);
	while instr:
		var key := _make_node_id();
		var idx := instr.get_start();
		var full := instr.get_string();
		var instr_name := instr.get_string("instr");
		var params := instr.get_string("params");
		
		if params.is_empty() and instr_name in _tween_map: # Must be a tween call
			_collapse_map[key] = LTweenExe.new(instr_name,self);
		else: # It's a regular instruction
			var nodes := _collapse_params(params);
			_collapse_map[key] = LInstr.new(instr_name,nodes,self);
		text = text.erase(idx,full.length()).insert(idx,key+"\n");
		instr = _rinstr.search(text);
	return text;

func _collapse_params(text:String) -> Array[LangNode]:
	if text.is_empty(): return [];
	text = _collapse_identifiers(text);
	text = _collapse_recursion(text);
	var nodes : Array[LangNode];
	for param in text.split(','):
		var id := param.strip_edges();
		if id.is_empty(): nodes.append(null);
		else:
			if _collapse_map.has(id): nodes.append(_collapse_map[id]);
			else: error_out.error("Incorrect ID as a parameter (%s)"%id);
	return nodes;

func _collapse_identifiers(text:String) -> String:
	var identifier := _rid.search(text);
	while identifier:
		var id_name := identifier.get_string();
		var key := "";
		key = _make_node_id();
		_collapse_map[key] = LIdentifier.new(id_name,self);
		var idx := identifier.get_start();
		text = text.erase(idx,id_name.length()).insert(idx,key);
		identifier = _rid.search(text);
	return text;

## Search recursive patterns of parenthesis, method calls and array indexing.
func _collapse_recursion(text:String) -> String:
	var res := _find_recursion_positions(text);
	while res.x >= 0: # Recursion found!
		var c := text[res.x];
		
		var sub_str := text.substr(res.x+1,res.y-2); # Get inner expression (without parenthesis)
		var collapsed_exprs :=  _collapse_recursion(sub_str); # Collapse inner recursions first (if any).
		var ids := collapsed_exprs.split(",");
		
		var nodes : Array[LangNode];
		for id in ids: nodes.append(_collapse_map.get(id.strip_edges()));
		
		if res.z >= 0: # Method Call or Array Access
			var id_name := text.substr(res.z,res.x-res.z);
			if c == "(":
				var key := _make_node_id();
				_collapse_map[key] = LMethodCall.new(id_name,nodes,self);
				text = text.erase(res.z,id_name.length()+res.y).insert(res.z,key);
			else:
				if ids.size() != 1:
					error_out.error("Operator [] must have exactly one parameter (%s)"%sub_str);
					return "";
				var key := _make_node_id();
				_collapse_map[key] = LArrayAccess.new(id_name,nodes[0],self);
				text = text.erase(res.z,id_name.length()+res.y).insert(res.z,key);
		else: # Recursive Expr or Array Constructor
			if c == "(":
				if ids.size() != 1:
					error_out.error("Recursive expressions must have exactly one parameter (%s)"%sub_str);
					return "";
				text = text.erase(res.x,res.y).insert(res.x,collapsed_exprs.strip_edges());
			else:
				var key := _make_node_id();
				_collapse_map[key] = LConstArray.new(nodes);
				text = text.erase(res.x,res.y).insert(res.x,key);

		res = _find_recursion_positions(text);

	# No recursion left, can collapse expressions
	text = _collapse_expr(text);
	return text;

## x component is index of symbol, y component is recursion's length, z component is index of first ID. 
## Both values can be -1 if didn't find its respective characters.
func _find_recursion_positions(text:String) -> Vector3i:
	var rec_start := -1;
	var type : String;
	var id_start := -1;
	for i in text.length():
		var c := text[i];
		if c == "#": id_start = i;
		if c == "(" or c == "[": 
			rec_start = i;
			type = c;
			break;
	if rec_start == -1: return Vector3i(-1,-1,-1);
	# Find recursion ending symbol
	var depth := 1;
	var search_rec_idx := rec_start + 1;
	if type == "(":
		while search_rec_idx < text.length() and depth > 0:
			var c := text[search_rec_idx];
			if c  == '(': depth += 1;
			elif c  == ')': depth -= 1;
			search_rec_idx += 1;
	elif type == "[":
		while search_rec_idx < text.length() and depth > 0:
			var c := text[search_rec_idx];
			if c  == '[': depth += 1;
			elif c  == ']': depth -= 1;
			search_rec_idx += 1;
	if depth > 0: # Bad grammar, open parenthesis should have closing pair
		error_out.error("Parse error, recursion in '%s' doesn't have its respective ending symbol."%text);
		return Vector3i(-1,-1,-1);
	
	if id_start >= 0:
		# Check if recursion belongs to the id (discarded if not)
		var number := text.substr(id_start+1,rec_start-(id_start+1));
		if not number.is_valid_int():
			id_start = -1; # Discard

	var rec_len := search_rec_idx - rec_start;
	return Vector3i(rec_start,rec_len,id_start);

## Focus on operators
func _collapse_expr(text:String) -> String:
	# Operators in descendent order of priority.
	var access := _rma.search(text);
	while access:
		var key := _make_node_id();
		var start := access.get_start();
		var end := access.get_end();
		text = text.erase(start,end-start).insert(start,key);
		
		var p := access.get_string("parent");
		var m := access.get_string("member");
		_collapse_map[key] = LDeReference.new(_collapse_map[p],_collapse_map[m],self);
		access = _rma.search(text);
	
	var unary := _runa.search(text);
	while unary:
		var key := _make_node_id();
		var val := unary.get_string();
		var idx := unary.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);
		
		var op := unary.get_string("op");
		var v1 := unary.get_string("v1");
		#if !op.is_empty(): 
		match op:
			"+": _collapse_map[key] = LPlus.new(_collapse_map[v1]);
			"-": _collapse_map[key] = LMinus.new(_collapse_map[v1]);
			"!": _collapse_map[key] = LNotLogic.new(_collapse_map[v1]);
			"~": _collapse_map[key] = LNotBit.new(_collapse_map[v1]);
		unary = _runa.search(text);
	
	var mul := _rmul.search(text);
	while mul:
		var key := _make_node_id();
		var val := mul.get_string();
		var idx := mul.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var op := mul.get_string("op");
		var v1 := mul.get_string("v1");
		var v2 := mul.get_string("v2");
		#if !op.is_empty():
		match op:
			"*": _collapse_map[key] = LMul.new(_collapse_map[v1],_collapse_map[v2]);
			"/": _collapse_map[key] = LDiv.new(_collapse_map[v1],_collapse_map[v2]);

		mul = _rmul.search(text);
		#print(fragment)
	var add := _radd.search(text);
	while add:
		var key := _make_node_id();
		var val := add.get_string();
		var idx := add.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var op := add.get_string("op");
		var v1 := add.get_string("v1");
		var v2 := add.get_string("v2");
		#if !op.is_empty():
		match op:
			"+": _collapse_map[key] = LAdd.new(_collapse_map[v1],_collapse_map[v2]);
			"-":_collapse_map[key] = LSub.new(_collapse_map[v1],_collapse_map[v2]);
		add = _radd.search(text);
	
	var shift := _rshf.search(text);
	while shift:
		var key := _make_node_id();
		var val := shift.get_string();
		var idx := shift.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var op := shift.get_string("op");
		var v1 := shift.get_string("v1");
		var v2 := shift.get_string("v2");
		#if !op.is_empty(): 
		match op:
			"<<": _collapse_map[key] = LShiftL.new(_collapse_map[v1],_collapse_map[v2]);
			">>": _collapse_map[key] = LShiftR.new(_collapse_map[v1],_collapse_map[v2]);
		shift = _rshf.search(text);
		
	var rel := _rrel.search(text);
	while rel:
		var key := _make_node_id();
		var val := rel.get_string();
		var idx := rel.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var op := rel.get_string("op");
		var v1 := rel.get_string("v1");
		var v2 := rel.get_string("v2");
		#if !op.is_empty(): 
		match op:
			">": _collapse_map[key] = LGT.new(_collapse_map[v1],_collapse_map[v2]);
			"<": _collapse_map[key] = LLT.new(_collapse_map[v1],_collapse_map[v2]);
			">=": _collapse_map[key] = LGE.new(_collapse_map[v1],_collapse_map[v2]);
			"<=": _collapse_map[key] = LLE.new(_collapse_map[v1],_collapse_map[v2]);
		rel = _rrel.search(text);
		
	var eq := _req.search(text);
	while eq:
		var key := _make_node_id();
		var val := eq.get_string();
		var idx := eq.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var op := eq.get_string("op");
		var v1 := eq.get_string("v1");
		var v2 := eq.get_string("v2");
		#if !op.is_empty(): 
		match op:
			"==": _collapse_map[key] = LEQ.new(_collapse_map[v1],_collapse_map[v2]);
			"!=": _collapse_map[key] = LNEQ.new(_collapse_map[v1],_collapse_map[v2]);
		eq = _req.search(text);
		
	var and_ := _rand.search(text);
	while and_:
		var key := _make_node_id();
		var val := and_.get_string();
		var idx := and_.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var v1 := and_.get_string("v1");
		var v2 := and_.get_string("v2");
		#if !v2.is_empty():
		_collapse_map[key] = LAnd.new(_collapse_map[v1],_collapse_map[v2]);
		and_ = _rand.search(text);
		
	var xor := _rxor.search(text);
	while xor:
		var key := _make_node_id();
		var val := xor.get_string();
		var idx := xor.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var v1 := xor.get_string("v1");
		var v2 := xor.get_string("v2");
		#if !v2.is_empty():
		_collapse_map[key] = LXor.new(_collapse_map[v1],_collapse_map[v2]);
		xor = _rxor.search(text);
	
	var or_ := _ror.search(text);
	while or_:
		var key := _make_node_id();
		var val := or_.get_string();
		var idx := or_.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var v1 := or_.get_string("v1");
		var v2 := or_.get_string("v2");
		#if !v2.is_empty():
		_collapse_map[key] = LOr.new(_collapse_map[v1],_collapse_map[v2]);
		or_ = _ror.search(text);
		
	var andl := _randl.search(text);
	while andl:
		var key := _make_node_id();
		var val := andl.get_string();
		var idx := andl.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var v1 := andl.get_string("v1");
		var v2 := andl.get_string("v2");
		#if !v2.is_empty():
		_collapse_map[key] = LAndL.new(_collapse_map[v1],_collapse_map[v2]);
		andl = _randl.search(text);
		
	var orl := _rorl.search(text);
	while orl:
		var key := _make_node_id();
		var val := orl.get_string();
		var idx := orl.get_start();
		text = text.erase(idx,val.length()).insert(idx,key);

		var v1 := orl.get_string("v1");
		var v2 := orl.get_string("v2");
		#if !v2.is_empty():
		_collapse_map[key] = LOrL.new(_collapse_map[v1],_collapse_map[v2]);
		orl = _rorl.search(text);
	return text;

## Set root node and join base instructions horizontally
func _join_instructions(text:String) -> void:
	var instr_ids := text.strip_edges().split("\n",false);
	
	if instr_ids.size() > 0:
		root_node = _collapse_map.get(instr_ids[0],null) as LInstr;
	var prev_node := root_node;
	
	for i in range(1,instr_ids.size()):
		var id := instr_ids[i];
		var node : LangNode =_collapse_map.get(id,null);
		if node == null:
			error_out.error("Bad error. The following part could not be parsed at all: %s"%id);
		if node is LInstr:
			var l := node as LInstr;
			prev_node.next = l;
			prev_node = l;


func _make_node_id() -> String:
	var id := "#%d"%_counter;
	_counter += 1;
	return id;
