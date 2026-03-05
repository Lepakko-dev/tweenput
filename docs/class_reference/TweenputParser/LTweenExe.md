---
layout: default-title
title: LTweenExe
parent: TweenputParser
---

Extends [LInstr][TweenputParser.LInstr]

Represents a single [Tween] execution.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#_parser) | [TweenputParser] | `` |
| [tween](#tween) | [Tween] | `` |

# Methods

| Return Type | Name |
|:-|:-|
| void | [_init](#_init)(tween_id: [String], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |
| [Callable] | [execute](#execute)() |

# Property Descriptions

[TweenputParser] _parser
{: #_parser }


---

[Tween] tween
{: #tween }


---

# Method Descriptions

void _init(tween_id: [String], parser: [TweenputParser])
{: #_init }


---

[Variant] value()
{: #value }


---

[Callable] execute()
{: #execute }

> Returns the play method of the represented tween.
 Also builds the tween if it has a definition.

---

[LTweenExe]: LTweenExe

[TweenputParser.LInstr]: /class_reference/TweenputParser/LInstr
[TweenputParser]: /class_reference/TweenputParser

[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[Tween]: https://docs.godotengine.org/en/stable/classes/class_tween.html

