---
layout: default-title
title: LMethodCall
parent: TweenputParser
---

Extends [LVar][TweenputParser.LVar]

Represents a method call of any existing method of an [Object] derived class.
 Some methods and constructors from [Variant] derived classes (that are not [Object])
 are implemented as well.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_node](#_node) | [LVar][TweenputParser.LVar] | `` |
| [_params](#_params) | [Array]\[[LangNode]\] | `` |
| [_parser](#_parser) | [TweenputParser] | `` |
| [_cached_instr](#_cached_instr) | [Callable] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [_init](#_init)(id: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |

# Property Descriptions

[LVar][TweenputParser.LVar] _node
{: #_node }


---

[Array]\[[LangNode]\] _params
{: #_params }


---

[TweenputParser] _parser
{: #_parser }


---

[Callable] _cached_instr
{: #_cached_instr }


---

# Method Descriptions

 _init(id: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #_init }


---

[Variant] value()
{: #value }


---

[LMethodCall]: LMethodCall

[TweenputParser.LVar]: /class_reference/TweenputParser/LVar
[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode
[TweenputParser]: /class_reference/TweenputParser

[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[Object]: https://docs.godotengine.org/en/stable/classes/class_object.html

