---
layout: default-title
title: LVar
parent: TweenputParser
---

Abstract
{: .label }

Extends: [LangNode]

Groups all nodes that handle variable data (to group nodes usually checked together in instructions).

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [ref_ctx](#ref_ctx) | [Variant] | |

# Property Descriptions

- [Variant] ref_ctx
{: #ref_ctx }

Stores the parent reference (necessary because de-reference descends the tree instead of ascending it)


[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[LangNode]: class_LangNode