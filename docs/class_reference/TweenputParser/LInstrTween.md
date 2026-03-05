---
layout: default-title
title: LInstrTween
parent: TweenputParser
---

Extends [LInstr][TweenputParser.LInstr]

Instruction node exclusive to [Tween] definition.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_m_name](#_m_name) | [String] | `` |
| [_parser](#_parser) | [TweenputParser] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [_init](#_init)(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser]) |
| [Callable] | [execute](#execute)() |

# Property Descriptions

[String] _m_name
{: #_m_name }


---

[TweenputParser] _parser
{: #_parser }


---

# Method Descriptions

 _init(name: [String], params: [Array]\[[LangNode]\], parser: [TweenputParser])
{: #_init }


---

[Callable] execute()
{: #execute }

> Calculates the most recent values of all parameters and executes the instruction
 represented into the current tween being built.

---

[LInstrTween]: LInstrTween

[TweenputParser.LInstr]: /class_reference/TweenputParser/LInstr
[TweenputParser]: /class_reference/TweenputParser
[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode

[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html

