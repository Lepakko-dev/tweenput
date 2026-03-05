---
layout: default-title
title: LTweenDef
parent: TweenputParser
---

Extends [LangNode][TweenputParser.LangNode]

Contains the whole [Tween] definition with all instructions.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_instr_list](#_instr_list) | [Array]\[[LInstrTween]\] | `` |
| [_parser](#_parser) | [TweenputParser] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [_init](#_init)(name: [String], instr_list: [Array]\[[LInstrTween]\], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |
| void | [execute](#execute)() |

# Property Descriptions

[Array]\[[LInstrTween]\] _instr_list
{: #_instr_list }


---

[TweenputParser] _parser
{: #_parser }


---

# Method Descriptions

 _init(name: [String], instr_list: [Array]\[[LInstrTween]\], parser: [TweenputParser])
{: #_init }


---

[Variant] value()
{: #value }


---

void execute()
{: #execute }

> Builds the whole [Tween] with updated parameters

---

[LTweenDef]: LTweenDef

[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode
[TweenputParser.LInstrTween]: /class_reference/TweenputParser/LInstrTween
[TweenputParser]: /class_reference/TweenputParser

[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html

