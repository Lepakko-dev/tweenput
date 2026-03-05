---
layout: default-title
title: TweenputLogger
parent: Class Reference
has_toc: false
---

Extends [RefCounted]

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_out](#_out) | [Callable] | `` |
| [_label](#_label) | [RichTextLabel] | `` |
| [_skip](#_skip) | [bool] | `` |

# Methods

| Return Type | Name |
|:-|:-|
| void | [_init](#_init)() |
|  | [enable](#enable)(value: [bool] = true) |
| void | [use_label](#use_label)(target: [RichTextLabel] = null) |
| void | [clear_label](#clear_label)() |
| void | [err](#err)(msg: [String]) |
| void | [warn](#warn)(msg: [String]) |
| void | [p_log](#p_log)(msg: [String]) |
|  | [_send_to_console](#_send_to_console)(msg: [String], danger: [DangerLevel] = [DangerLevel].NONE) |
|  | [_send_to_label](#_send_to_label)(msg: [String], danger: [DangerLevel] = [DangerLevel].NONE) |

# Enumerations

enum DangerLevel:
{: #DangerLevel }

> NONE = 0
> {: #DangerLevel.NONE }


> WARN = 1
> {: #DangerLevel.WARN }


> ERROR = 2
> {: #DangerLevel.ERROR }


# Property Descriptions

[Callable] _out
{: #_out }


---

[RichTextLabel] _label
{: #_label }


---

[bool] _skip
{: #_skip }


---

# Method Descriptions

void _init()
{: #_init }


---

 enable(value: [bool] = true)
{: #enable }


---

void use_label(target: [RichTextLabel] = null)
{: #use_label }


---

void clear_label()
{: #clear_label }


---

void err(msg: [String])
{: #err }


---

void warn(msg: [String])
{: #warn }


---

void p_log(msg: [String])
{: #p_log }


---

 _send_to_console(msg: [String], danger: [DangerLevel] = [DangerLevel].NONE)
{: #_send_to_console }


---

 _send_to_label(msg: [String], danger: [DangerLevel] = [DangerLevel].NONE)
{: #_send_to_label }


---

[TweenputLogger]: TweenputLogger


[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[bool]: https://docs.godotengine.org/en/stable/classes/class_bool.html
[RefCounted]: https://docs.godotengine.org/en/stable/classes/class_refcounted.html
[RichTextLabel]: https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html

