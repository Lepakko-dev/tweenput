---
layout: default-title
title: LInstr
parent: TweenputParser
---

Extends [LangNode][TweenputParser.LangNode]

Holds information of a whole instruction with parameters if any.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [next](#next) | [LInstr] | `` |
| [_params](#_params) | [Array]\[[LangNode]\] | `` |
| [_cached_instr](#_cached_instr) | [Callable] | `` |

# Methods

| Return Type | Name |
|:-|:-|
| void | [_init](#_init)(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |
| [Callable] | [execute](#execute)() |

# Property Descriptions

[LInstr] next
{: #next }


---

[Array]\[[LangNode]\] _params
{: #_params }


---

[Callable] _cached_instr
{: #_cached_instr }


---

# Method Descriptions

void _init(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #_init }


---

[Variant] value()
{: #value }


---

[Callable] execute()
{: #execute }

> Returns a callable of the instruction it represents with all parameters already set.

---

[LInstr]: LInstr

[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode
[TweenputParser]: /class_reference/TweenputParser

[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html

