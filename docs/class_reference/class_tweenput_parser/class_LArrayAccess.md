---
layout: default-title
title: LArrayAccess
parent: TweenputParser
---

Extends: [LVar]

A way to access the contents of an array or dictionary variable (whether it's typed or not).

Example: `array[index]`, `dict[key]`.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#parser) | [TweenputParser] | |
| [_node](#node) | [LVar] | |
| [_idx](#idx) | [LangNode] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(id: [String], idx: [LangNode], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |

# Property Descriptions

- [TweenputParser] _parser
{: #parser }

A reference to the parser to use at execution time.

- [LVar] _node
{: #node }

The node that holds the array or dictionary.

- [LangNode] _idx
{: #idx }

The node that holds the index or key to access the container.

# Method Descriptions

- void _init(name: [Variant], parser: [TweenputParser])
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
[LBinOp]: class_LBinOp
[LVar]: class_LVar