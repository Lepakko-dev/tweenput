---
layout: default-title
title: Context
parent: Tweenterpreter
---

Execution-time data related to the flow of the interpreter

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [flags](#flags) | [int] | `0` |
| [jmp_target](#jmp_target) | [TweenputParser] | `` |
| [call_stack](#call_stack) | [Array] | `` |

# Methods

| Return Type | Name |
|:-|:-|
| void | [reset](#reset)() |

# Property Descriptions

[int] flags = ```0```
{: #flags }

> Set of [Tweenterpreter.RUN_FLAG][Tweenterpreter#RUN_FLAG] flags.

---

[TweenputParser] jmp_target
{: #jmp_target }

> The instruction node where the interpreter should jump if any related flag is active.

---

[Array] call_stack
{: #call_stack }

> Stack of instructions to return to when a sub-routine ends.

---

# Method Descriptions

void reset()
{: #reset }


---

[Context]: Context

[Tweenterpreter.RUN_FLAG]: /class_reference/Tweenterpreter/RUN_FLAG
[TweenputParser]: /class_reference/TweenputParser

[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[int]: https://docs.godotengine.org/en/stable/classes/class_int.html

