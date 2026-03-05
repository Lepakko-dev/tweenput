---
layout: default-title
title: TweenputParser
parent: Class Reference
has_toc: false
---

Extends [Node]

Parses a text following the Tweenput grammar and turns it into an executable AST

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_rconst](#_rconst) |  | `RegEx.create_from_string(CONST)` |
| [_rstring](#_rstring) |  | `RegEx.create_from_string(STRING)` |
| [_rmacro](#_rmacro) |  | `RegEx.create_from_string(MACRO)` |
| [_rid](#_rid) |  | `RegEx.create_from_string(ID)` |
| [_rsep](#_rsep) |  | `RegEx.create_from_string(SEP)` |
| [_rma](#_rma) |  | `RegEx.create_from_string(MEMBR_ACCESS_EXPR)` |
| [_runa](#_runa) |  | `RegEx.create_from_string(UNARY_EXPR)` |
| [_rmul](#_rmul) |  | `RegEx.create_from_string(MUL_EXPR)` |
| [_radd](#_radd) |  | `RegEx.create_from_string(ADD_EXPR)` |
| [_rshf](#_rshf) |  | `RegEx.create_from_string(SHIFT_EXPR)` |
| [_rrel](#_rrel) |  | `RegEx.create_from_string(REL_EXPR)` |
| [_req](#_req) |  | `RegEx.create_from_string(EQ_EXPR)` |
| [_rand](#_rand) |  | `RegEx.create_from_string(AND_EXPR)` |
| [_rxor](#_rxor) |  | `RegEx.create_from_string(XOR_EXPR)` |
| [_ror](#_ror) |  | `RegEx.create_from_string(OR_EXPR)` |
| [_randl](#_randl) |  | `RegEx.create_from_string(LOGIC_AND_EXPR)` |
| [_rorl](#_rorl) |  | `RegEx.create_from_string(LOGIC_OR_EXPR)` |
| [_rinstr](#_rinstr) |  | `RegEx.create_from_string(INSTR)` |
| [_rtween](#_rtween) |  | `RegEx.create_from_string(TWEEN_DEF)` |
| [_rlabel](#_rlabel) |  | `RegEx.create_from_string(LABEL)` |
| [_rcomment](#_rcomment) |  | `RegEx.create_from_string(COMMENT)` |
| [instructions](#instructions) | [Dictionary]\[[String], [Callable]\] | `{}` |
| [variables](#variables) | [Dictionary]\[[String], [Variant]\] | `{}` |
| [current_building_tween](#current_building_tween) | [Tween] | `` |
| [root_node](#root_node) | [LInstr] | `` |
| [label_map](#label_map) | [Dictionary]\[[String], [LInstr]\] | `` |
| [_tween_map](#_tween_map) | [Dictionary]\[[String], [LTweenDef]\] | `` |
| [_collapse_map](#_collapse_map) | [Dictionary]\[[String], [LangNode]\] | `` |
| [_counter](#_counter) |  | `0` |
| [logger](#logger) |  | `TweenputLogger.new()` |

# Methods

| Return Type | Name |
|:-|:-|
| [String] | [parse](#parse)(text: [String]) |
| [String] | [_remove_comments](#_remove_comments)(text: [String]) |
| [String] | [_apply_macros](#_apply_macros)(text: [String]) |
| [String] | [_collapse_literals](#_collapse_literals)(text: [String]) |
| [String] | [_remove_spaces](#_remove_spaces)(text: [String]) |
| [String] | [_collapse_labels](#_collapse_labels)(text: [String]) |
| [String] | [_collapse_tween_defs](#_collapse_tween_defs)(text: [String]) |
| [String] | [_collapse_t_instr](#_collapse_t_instr)(text: [String], list: [Array]\[[LInstrTween]\]) |
| [String] | [_collapse_instr](#_collapse_instr)(text: [String]) |
| [Array]\[[LangNode]\] | [_collapse_params](#_collapse_params)(text: [String]) |
| [String] | [_collapse_identifiers](#_collapse_identifiers)(text: [String]) |
| [String] | [_collapse_recursion](#_collapse_recursion)(text: [String]) |
| [Vector3i] | [_find_recursion_positions](#_find_recursion_positions)(text: [String]) |
| [String] | [_collapse_expr](#_collapse_expr)(text: [String]) |
| void | [_join_instructions](#_join_instructions)(text: [String]) |
| [String] | [_make_node_id](#_make_node_id)() |

# Inner Classes

- [LangNode]
- [LInstr]
- [LInstrTween]
- [LString]
- [LConst]
- [LConstArray]
- [LTweenDef]
- [LTweenExe]
- [LVar]
- [LIdentifier]
- [LBinOp]
- [LDeReference]
- [LMethodCall]
- [LArrayAccess]
- [LUnary]

# Constants

STRING `=r'"(?<val>(?:[^"\n]|(?:\\"))*)"'`
{: #STRING }

MACRO `=r'@(?<val>[A-Z_0-9]+)'`
{: #MACRO }

CONST `=r"(?<![A-Za-z_#]{1,9}\d{0,9})(?:(?<bin>0b(?:[0-1])+)|(?<hex>0x(?:\d|[a-f])+)|(?<dec>\d+(?:\.\d*)?))"`
{: #CONST }

ID `=r"(?<obj>[a-zA-Z_]\w*)"`
{: #ID }

MEMBR_ACCESS_EXPR `=r"(?<parent>#\d+)\.(?<member>#\d+)";`
{: #MEMBR_ACCESS_EXPR }

UNARY_EXPR `=r"(?<=\+|-|~|!|\D|^)(?<op>\+|-|~|!)(?<v1>#\d+)"`
{: #UNARY_EXPR }

MUL_EXPR `=r"(?<v1>#\d+)(?<op>\*|\/)(?<v2>#\d+)"`
{: #MUL_EXPR }

ADD_EXPR `=r"(?<v1>#\d+)(?<op>\+|-)(?<v2>#\d+)"`
{: #ADD_EXPR }

SHIFT_EXPR `=r"(?<v1>#\d+)(?<op>>>|<<)(?<v2>#\d+)"`
{: #SHIFT_EXPR }

REL_EXPR `=r"(?<v1>#\d+)(?<op>>|<|>=|<=)(?<v2>#\d+)"`
{: #REL_EXPR }

EQ_EXPR `=r"(?<v1>#\d+)(?<op>==|!=)(?<v2>#\d+)"`
{: #EQ_EXPR }

AND_EXPR `=r"(?<v1>#\d+)&(?<v2>#\d+)"`
{: #AND_EXPR }

XOR_EXPR `=r"(?<v1>#\d+)\^(?<v2>#\d+)"`
{: #XOR_EXPR }

OR_EXPR `=r"(?<v1>#\d+)\|(?<v2>#\d+)"`
{: #OR_EXPR }

LOGIC_AND_EXPR `=r"(?<v1>#\d+)&&(?<v2>#\d+)"`
{: #LOGIC_AND_EXPR }

LOGIC_OR_EXPR `=r"(?<v1>#\d+)\|\|(?<v2>#\d+)"`
{: #LOGIC_OR_EXPR }

INSTR `=LOOKBREAK + r"(?<instr>[a-zA-Z_]\w*)(?:" + H + r"(?<params>[^\n;:{]+)?)?(?:[\n;]|$)"`
{: #INSTR }

LABEL `=LOOKBREAK + r"(?<label>[a-zA-Z_]\w*):(?:[^\S]*)(?<node>#\d+)"`
{: #LABEL }

TWEEN_DEF `=LOOKBREAK + r"(" + ID + r"[^\S\n]*\{(?<list>(?:[\n;]*\s*(?:[^\n;}]+)?)*)?\})";`
{: #TWEEN_DEF }

H `=r"(?:[^\S\n])"`
{: #H }

SEP `=r"(?:[^\S\n]+)"`
{: #SEP }

LOOKBREAK `=r"(?<=(?:\n|;|^)\s{0,99})"`
{: #LOOKBREAK }

COMMENT `=r'(?<!(\n|^)[^"]{0,99}"[^"]{0,99})#[^\n]*'`
{: #COMMENT }

TWEEN_INSTRUCTIONS `=...`
{: #TWEEN_INSTRUCTIONS }

> Exclusive instructions for Tween definition only.

# Property Descriptions

_rconst = ```RegEx.create_from_string(CONST)```
{: #_rconst }


---

_rstring = ```RegEx.create_from_string(STRING)```
{: #_rstring }


---

_rmacro = ```RegEx.create_from_string(MACRO)```
{: #_rmacro }


---

_rid = ```RegEx.create_from_string(ID)```
{: #_rid }


---

_rsep = ```RegEx.create_from_string(SEP)```
{: #_rsep }


---

_rma = ```RegEx.create_from_string(MEMBR_ACCESS_EXPR)```
{: #_rma }


---

_runa = ```RegEx.create_from_string(UNARY_EXPR)```
{: #_runa }


---

_rmul = ```RegEx.create_from_string(MUL_EXPR)```
{: #_rmul }


---

_radd = ```RegEx.create_from_string(ADD_EXPR)```
{: #_radd }


---

_rshf = ```RegEx.create_from_string(SHIFT_EXPR)```
{: #_rshf }


---

_rrel = ```RegEx.create_from_string(REL_EXPR)```
{: #_rrel }


---

_req = ```RegEx.create_from_string(EQ_EXPR)```
{: #_req }


---

_rand = ```RegEx.create_from_string(AND_EXPR)```
{: #_rand }


---

_rxor = ```RegEx.create_from_string(XOR_EXPR)```
{: #_rxor }


---

_ror = ```RegEx.create_from_string(OR_EXPR)```
{: #_ror }


---

_randl = ```RegEx.create_from_string(LOGIC_AND_EXPR)```
{: #_randl }


---

_rorl = ```RegEx.create_from_string(LOGIC_OR_EXPR)```
{: #_rorl }


---

_rinstr = ```RegEx.create_from_string(INSTR)```
{: #_rinstr }


---

_rtween = ```RegEx.create_from_string(TWEEN_DEF)```
{: #_rtween }


---

_rlabel = ```RegEx.create_from_string(LABEL)```
{: #_rlabel }


---

_rcomment = ```RegEx.create_from_string(COMMENT)```
{: #_rcomment }


---

[Dictionary]\[[String], [Callable]\] instructions = ```{}```
{: #instructions }

> Map of all instruction names with their implementation. Feel free to add or modify. <br>
 Is filled automatically if the parent node is [Tweenterpreter].

---

[Dictionary]\[[String], [Variant]\] variables = ```{}```
{: #variables }

> Maps variable names with its values. Feel free to add variables from outside
 this class so the code can use them during execution.

---

[Tween] current_building_tween
{: #current_building_tween }

> Auxiliar variable to hold a reference to a [Tween] during its building phase
 in a tween definition.

---

[LInstr] root_node
{: #root_node }

> First instruction in parsed code.

---

[Dictionary]\[[String], [LInstr]\] label_map
{: #label_map }

> Maps all labels to the instruction they point to.

---

[Dictionary]\[[String], [LTweenDef]\] _tween_map
{: #_tween_map }

> Holds all [Tween] definitions so executed tweens can rebuild themselves at execution time.

---

[Dictionary]\[[String], [LangNode]\] _collapse_map
{: #_collapse_map }

> Holds the translations of certain syntax when collapsed to a unique node identifier.

---

_counter = ```0```
{: #_counter }

> Counter to make collapsed nodes have an unique identifier.

---

logger = ```TweenputLogger.new()```
{: #logger }


---

# Method Descriptions

[String] parse(text: [String])
{: #parse }

> Parses the whole text and creates an AST whose root is stored in [root_node](#root_node)

---

[String] _remove_comments(text: [String])
{: #_remove_comments }


---

[String] _apply_macros(text: [String])
{: #_apply_macros }


---

[String] _collapse_literals(text: [String])
{: #_collapse_literals }


---

[String] _remove_spaces(text: [String])
{: #_remove_spaces }

> Removes all non-newline space related characters

---

[String] _collapse_labels(text: [String])
{: #_collapse_labels }


---

[String] _collapse_tween_defs(text: [String])
{: #_collapse_tween_defs }


---

[String] _collapse_t_instr(text: [String], list: [Array]\[[LInstrTween]\])
{: #_collapse_t_instr }

> Groups all tween instructions of a tween definition

---

[String] _collapse_instr(text: [String])
{: #_collapse_instr }

> Collapse all instructions with its parameters. Also collapses [Tween] calls.

---

[Array]\[[LangNode]\] _collapse_params(text: [String])
{: #_collapse_params }


---

[String] _collapse_identifiers(text: [String])
{: #_collapse_identifiers }


---

[String] _collapse_recursion(text: [String])
{: #_collapse_recursion }

> Search recursive patterns by parenthesis, method calls and array indexing.

---

[Vector3i] _find_recursion_positions(text: [String])
{: #_find_recursion_positions }

> Returns three index grouped in a [Vector3i] where:<br>
 - x = index of first symbol ```(``` or ```[```.<br> 
 - y = length of recursion.<br>
 - z = index of first ID.<br><br>
 Values will be -1 if didn't find its respective characters.

---

[String] _collapse_expr(text: [String])
{: #_collapse_expr }

> Collapses each operator found by priority order and from left to right.

---

void _join_instructions(text: [String])
{: #_join_instructions }

> Set root node and join base instructions horizontally

---

[String] _make_node_id()
{: #_make_node_id }


---

[TweenputParser]: TweenputParser
[LangNode]: LangNode
[LInstr]: LInstr
[LInstrTween]: LInstrTween
[LString]: LString
[LConst]: LConst
[LConstArray]: LConstArray
[LTweenDef]: LTweenDef
[LTweenExe]: LTweenExe
[LVar]: LVar
[LIdentifier]: LIdentifier
[LBinOp]: LBinOp
[LDeReference]: LDeReference
[LMethodCall]: LMethodCall
[LArrayAccess]: LArrayAccess
[LUnary]: LUnary

[Tweenterpreter]: /class_reference/Tweenterpreter

[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[Vector3i]: https://docs.godotengine.org/en/stable/classes/class_vector3i.html
[Node]: https://docs.godotengine.org/en/stable/classes/class_node.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html

