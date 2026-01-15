---
layout: default-title
title: LMethodCall
parent: TweenputParser
---

Extends: [LVar]

Represents a method call of any existing method of an [Object] derived class. 

Some methods and constructors from [Variant] derived classes (that are not [Object]) are implemented as well.

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#parser) | [TweenputParser] | |
| [_node](#node) | [LVar] | |
| [_params](#params) | [Array]\[[LangNode]\] | |
| [_cached_instr](#cached_instr) | [Callable] | |

# Methods

| Type | Name |
|:-|:-|
| void | [_init](#init)(left_var: [LangNode], right_var: [LangNode], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |

# Property Descriptions

- [TweenputParser] _parser
{: #parser }

A reference to the parser to use at execution time.

- [LVar] _node
{: node }

The node that holds the method/function name.

- [Array]\[[LangNode]\] _params
{: params }

Each parameter passed to the method/function. From left to right.

- [Callable] _cached_instr
{: cached_instr }

A reference to the method it is supposed to call (does not include parameters).

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