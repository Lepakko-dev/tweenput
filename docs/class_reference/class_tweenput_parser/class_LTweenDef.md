---
layout: default-title
title: LTweenDef
parent: TweenputParser
---

Extends: [LangNode]

Contains the whole [Tween] definition with all instructions.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_instr_list](#instr_list) | [Array]\[[LInstrTween]\] | |
| [_parser](#parser) | [TweenputParser] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(name: [String], instr_list: [Array]\[[LInstrTween]\], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |
| [Callable] | [execute](#execute)() |

# Property Descriptions

- [Array]\[[LInstrTween]\] _instr_list
{: #instr_list }

List of tween instructions inside this definition.

- [TweenputParser] _parser
{: #parser }

A reference to the parser to use at execution time. Used to access the [current_building_tween] member.

# Method Descriptions

- void _init(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #init }

- [Variant] value()
{: #value }

Will return the processed value of whatever it contains.

- [Callable] execute()
{: #execute }

Builds the whole [Tween] with updated parameters (it will even rebuild subtweens).


[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[Vector3i]: https://docs.godotengine.org/en/stable/classes/class_vector3i.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html
[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Node]: https://docs.godotengine.org/en/stable/classes/class_node.html

[LangNode]: class_LangNode
[LInstr]: class_LInstr
[TweenputParser]: index
[LInstrTween]: class_LInstrTween
[current_building_tween]: index#current_building_tween