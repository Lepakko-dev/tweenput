---
layout: default-title
title: LInstr
parent: TweenputParser
---

Extends: [LangNode]

Holds information of a whole instruction with parameters if any.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [next](#next) | [LInstr] | |
| [_params](#params) | [Array]\[[LangNode]\] | |
| [_cached_instr](#cached_instr) | [Callable] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |
| [Callable] | [execute](#execute)() |

# Property Descriptions

- [LInstr] next
{: #next }

Next instruction node to exeute after this one.

- [Array]\[[LangNode]\] _params
{: #params }

List of parameters passed to the instruction.

- [Callable] _cached_instr
{: #cached_instr }

Callable with the function this instruction node should call.

# Method Descriptions

- void _init(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #init }

- [Variant] value()
{: #value }

Will return the processed value of whatever it contains.

- [Callable] execute()
{: #execute }

Returns a callable of the instruction it represents with all parameters already set.


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