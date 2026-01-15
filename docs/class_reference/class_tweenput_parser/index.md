---
layout: default-title
title: TweenputParser
parent: Class Reference
has_toc: false
---

Extends [Node]

Parses a text following the Tweenput grammar and turns it into an executable AST.

# Index
{: .no_toc}

1. tock
{:toc}


# Description

TODO.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [instructions](#instructions) | [Dictionary]\[[String], [Callable]\] | {} |
| [variables](#variables) | [Dictionary]\[[String], [Variant]\] | {} |
| [current_building_tween](#current_building_tween) | [Tween] | |
| [root_node](#root_node) | [LInstr] | |
| [label_map](#label_map) | [Dictionary]\[[String], [LInstr]\] | |
| [logger](#logger) | [TweenputLogger] | |

# Methods

| Type | Name |
|:-|:-|
| [String] | [_collapse_expr](#_collapse_expr)(text: [String]) |
| [String] | [_collapse_instr](#_collapse_instr)(text: [String]) |
| [String] | [_collapse_recursion](#_collapse_recursion)(text: [String]) |
| [String] | [_collapse_t_instr](#_collapse_t_instr)(text: [String], list: [Array]\[[LInstrTween]\])
| [Vector3i] | [_find_recursion_positions](#_find_recursion_positions)(text: [String]) |
| void | [_join_instructions](#_join_instructions)(text: [String]) |
| [String] | [_remove_spaces](#_remove_spaces)(text: [String]) |
| [String] | [parse](#parse)(text: [String]) |

# Inner Classes

The TweenputParser contains a number of inner classes of nodes for the AST. Each inner class implements some part of the grammar. You can see all class documentation references under this class in the navigation bar to the left.

# Constants

- STRING `= "\"(?<val>(?:[^\"\\n]|(?:\\\\\"))*)\""`
- MACRO `= "@(?<val>[A-Z_0-9]+)"`
- CONST `= "(?<![A-Za-z_#]{1,9}\\d{0,9})(?:(?<bin>0b(?:[0-1])+)|(?<hex>0x(?:\\d|[a-f])+)|(?<dec>\\d+(?:\\.\\d*)?))"`
- ID `= "(?<obj>[a-zA-Z_]\\w*)"`
- MEMBR_ACCESS_EXPR `= "(?<parent>#\\d+)\\.(?<member>#\\d+)"`
- UNARY_EXPR `= "(?<=\\+|-|~|!|\\D|^)(?<op>\\+|-|~|!)(?<v1>#\\d+)"`
- MUL_EXPR `= "(?<v1>#\\d+)(?<op>\\*|\\/)(?<v2>#\\d+)"`
- ADD_EXPR `= "(?<v1>#\\d+)(?<op>\\+|-)(?<v2>#\\d+)"`
- SHIFT_EXPR `= "(?<v1>#\\d+)(?<op>>>|<<)(?<v2>#\\d+)"`
- REL_EXPR `= "(?<v1>#\\d+)(?<op>>|<|>=|<=)(?<v2>#\\d+)"`
- EQ_EXPR `= "(?<v1>#\\d+)(?<op>==|!=)(?<v2>#\\d+)"`
- AND_EXPR `= "(?<v1>#\\d+)&(?<v2>#\\d+)"`
- XOR_EXPR `= "(?<v1>#\\d+)\\^(?<v2>#\\d+)"`
- OR_EXPR `= "(?<v1>#\\d+)\\|(?<v2>#\\d+)"`
- LOGIC_AND_EXPR `= "(?<v1>#\\d+)&&(?<v2>#\\d+)"`
- LOGIC_OR_EXPR `= "(?<v1>#\\d+)\\|\\|(?<v2>#\\d+)"`
- INSTR `= "(?<=(?:\\n|;|^)\\s{0,99})(?<instr>[a-zA-Z_]\\w*)(?:(?:[^\\S\\n])(?<params>[^\\n;:{]+)?)?(?:[\\n;]|$)"`
- LABEL `= "(?<=(?:\\n|;|^)\\s{0,99})(?<label>[a-zA-Z_]\\w*):(?:[^\\S]*)(?<node>#\\d+)"`
- TWEEN_DEF `= "(?<=(?:\\n|;|^)\\s{0,99})((?<obj>[a-zA-Z_]\\w*)[^\\S\\n]*\\{(?<list>(?:[\\n;]*\\s*(?:[^\\n;}]+)?)*)?\\})"`
- H `= "(?:[^\\S\\n])"`
- SEP `= "(?:[^\\S\\n]+)"`
- LOOKBREAK `= "(?<=(?:\\n|;|^)\\s{0,99})"`
- COMMENT `= "(?<!(\\n|^)[^\"]{0,99}\"[^\"]{0,99})#[^\\n]*"`
- TWEEN_INSTRUCTIONS `= Dictionary[String, String]({"BIND": "bind_node", "CALLBACK": "tween_callback", "EASE": "set_ease", "IGNORE_TIME_SCALE": "set_ignore_time_scale", "INTERVAL": "tween_interval", "LOOPS": "set_loops", "METHOD": "tween_method", "PARALLEL": "set_parallel", "PAUSE_MODE": "set_pause_mode", "PROCESS_MODE": "set_process_mode", "PROPERTY": "tween_property", "SPEED_SCALE": "set_speed_scale", "SUBTWEEN": "tween_subtween", "TRANS": "set_trans"})`

# Property Descriptions

- [Tween] current_building_tween
{: #current_building_tween }

Auxiliar variable to hold a reference to a Tween during its building phase in a tween definition.

---

- [Dictionary]\[[String], [Callable]\] instructions `[default: {}]`
{: #instructions }

Map of all instruction names with their implementation. Feel free to add or modify. 

Is filled automatically if the parent node is Tweenterpreter.

---

- [Dictionary]\[[String], [LInstr]\] label_map
{: #label_map }

Maps all labels to the instruction they point to.

---

- [TweenputLogger] logger
{: #logger }

There is currently no description for this property.

---

- [LInstr] root_node
{: #root_node }

First instruction in parsed code.

---

- [Dictionary]\[[String], [Variant]\] variables `[default: {}]`
{: #variables }

Maps variable names with its values. Feel free to add variables from outside this class so the code can use them during execution.

# Method Descriptions
- [String] _collapse_expr(text: [String])
{: #_collapse_expr }

Collapses each operator found by priority order and from left to right.

---

- [String] _collapse_instr(text: [String])
{: #_collapse_instr }

Collapse all instructions with its parameters. Also collapses Tween calls.

---

- [String] _collapse_recursion(text: [String])
{: #_collapse_recursion }

Search recursive patterns by parenthesis, method calls and array indexing.

---

- [String] _collapse_t_instr(text: [String], list: [Array]\[[LInstrTween]\])
{: #_collapse_t_instr }

Groups all tween instructions of a tween definition.

---

- [Vector3i] _find_recursion_positions(text: [String])
{: #_find_recursion_positions }

Returns three index grouped in a Vector3i where:

    - x = index of first symbol `(` or `[`. Will be -1 if didn't find such symbols.

    - y = length of recursion. Will be -1 if no symbol is matched.

    - z = index of first ID. Will be -1 if no ID is found before the symbol.

---

- void _join_instructions(text: [String])
{: #_join_instructions }

Set root node and join base instructions horizontally.

---

- [String] _remove_spaces(text: [String])
{: #_remove_spaces }

Removes all non-newline space related characters.

---

- [String] parse(text: [String])
{: #parse }

Parses the whole text and creates an AST whose root is stored in root_node.


[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[Vector3i]: https://docs.godotengine.org/en/stable/classes/class_vector3i.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html
[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Node]: https://docs.godotengine.org/en/stable/classes/class_node.html

[LInstr]: class_LInstr