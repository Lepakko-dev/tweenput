---
layout: default-title
title: LangNode
parent: TweenputParser
---

Abstract
{: .label }

Base type of node for the AST

# Description

TODO

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [node_name](#node_name) | [String] | |

# Methods

| Type | Name |
|:-|:-|
| [Variant] | @abstract [value](#value)() |

# Property Descriptions

- [String] node_name
{: #node_name }

Doesn't need to be unique.

# Method Descriptions

- [Variant] @abstract value()
{: #value }

Will return the processed value of whatever it contains.


[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
