---
layout: default-title
title: LConst
parent: TweenputParser
---

Extends: [LangNode]

Any numeric value in integer, floating, binary and hexadecimal format.

Examples: `1`, `2.3`, `0b01`, `0x4f`.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_val](#val) | [Variant] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(number: [Variant]) |
| [Variant] | [value](#value)() |

# Property Descriptions

- [Variant] _val
{: #val }

The number. It can be integer or float.

# Method Descriptions

- void _init(number: [Variant])
{: #init }

- [Variant] value()
{: #value }

Will return the processed value of whatever it contains.


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