---
layout: default-title
title: LInstrTween
parent: TweenputParser
---

Extends: [LInstr]

Instruction node exclusive to [Tween] definitions.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_m_name](#m_name) | [String] | |
| [_parser](#parser) | [TweenputParser] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser]) |
| [Callable] | [execute](#execute)() |

# Property Descriptions

- [String] _m_name
{: #m_name }

Name of the [Tween] method this node is referencing.

- [TweenputParser] _parser
{: #parser }

A reference to the parser to use at execution time. Used to access the [current_building_tween] member.

# Method Descriptions

- void _init(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #init }

- [Callable] execute()
{: #execute }

Calculates the most recent values of all parameters and executes the instruction represented into the current tween being built.

Returns a reference to the already executed method (this is returned for completeness, don't actually use this callable).

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
[current_building_tween]: index#current_building_tween