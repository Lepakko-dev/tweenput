---
layout: default-title
title: LIdentifier
parent: TweenputParser
---

Extends: [LVar]

Represents a variable (or a class member).

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#parser) | [TweenputParser] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(name: [Variant], parser: [TweenputParser]) |
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
[LVar]: class_LVar