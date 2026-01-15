---
layout: default-title
title: LConstArray
parent: TweenputParser
---

Extends: [LangNode]

Represents an array of any type of values, including other arrays.

Example: [], ["any","Variant","type", 99, variable], [ [],[],[] ]

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_elems](#elems) | [Array]\[[LangNode]\] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(elems: [Array]\[[LangNode]\]) |
| [Variant] | [value](#value)() |

# Property Descriptions

- [Array]\[[LangNode]\] _elems
{: #elems }

List of every node inside the array, ordered from left to right.

# Method Descriptions

- void _init(elems: [Array]\[[LangNode]\])
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