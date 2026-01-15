---
layout: default-title
title: LDeReference
parent: TweenputParser
---

Extends: [LBinOp]

Represents the '.' operator used to access members and methods of objects.



# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#parser) | [TweenputParser] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(left_var: [LangNode], right_var: [LangNode], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |

# Property Descriptions

- [TweenputParser] _parser
{: #parser }

A reference to the parser to use at execution time.

# Method Descriptions

- void _init(name: [Variant], parser: [TweenputParser])
{: #init }

- [Variant] value()
{: #value }

Returns the recursively de-referenced value of the operation.


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