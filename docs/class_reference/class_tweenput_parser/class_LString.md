---
layout: default-title
title: LString
parent: TweenputParser
---

Extends: [LangNode]

Represents any double quoted string.

Example: `"Tween Twong"`.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_literal](#literal) | [String] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(name: [String]) |
| [Variant] | [value](#value)() |

# Property Descriptions

- [String] _literal
{: #literal }

The contents of the string literal.

# Method Descriptions

- void _init(name: [String])
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