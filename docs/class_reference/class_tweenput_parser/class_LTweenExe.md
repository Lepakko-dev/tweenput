---
layout: default-title
title: LTweenExe
parent: TweenputParser
---

Extends: [LInstr]

Represents a single [Tween] execution.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#parser) | [TweenputParser] | |
| [tween](#tween) | [Tween] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(tween_id: [String], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |
| [Callable] | [execute](#execute)() |

# Property Descriptions

- [TweenputParser] _parser
{: #parser }

A reference to the parser to use at execution time.

- [Tween] tween
{: #tween }

Reference to the executed tween. Gets assigned during [execute](#execute)().

# Method Descriptions

- void _init(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #init }

- [Variant] value()
{: #value }

Will return the processed value of whatever it contains.

- [Callable] execute()
{: #execute }

Returns the play method of the represented [Tween]. Also builds the [Tween] if it is defined in the code.


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