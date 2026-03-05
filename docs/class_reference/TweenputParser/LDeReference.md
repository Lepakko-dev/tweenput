---
layout: default-title
title: LDeReference
parent: TweenputParser
---

Extends [LBinOp][TweenputParser.LBinOp]

Represents the '.' operator used to access members and methods of objects.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_parser](#_parser) | [TweenputParser] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [_init](#_init)(left_var:[LangNode][TweenputParser.LangNode], right_var:[LangNode][TweenputParser.LangNode], parser: [TweenputParser]) |
| [Variant] | [value](#value)() |

# Property Descriptions

[TweenputParser] _parser
{: #_parser }


---

# Method Descriptions

 _init(left_var:[LangNode][TweenputParser.LangNode], right_var:[LangNode][TweenputParser.LangNode], parser: [TweenputParser])
{: #_init }


---

[Variant] value()
{: #value }

> Returns the recursively de-referenced value of the operation.

---

[LDeReference]: LDeReference

[TweenputParser.LBinOp]: /class_reference/TweenputParser/LBinOp
[TweenputParser]: /class_reference/TweenputParser
[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode

[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html

