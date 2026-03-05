---
layout: default-title
title: TimeWindow
parent: Class Reference
has_toc: false
---

This class represents the interval in which an input can be pressed.<br>
 It's not advised to use them for animations as is, use them in a [TimeWindowController] instead.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [center](#center) | [float] | `` |
| [radius](#radius) | [float] | `` |
| [pre_window](#pre_window) | [float] | `` |
| [post_window](#post_window) | [float] | `` |
| [mod_r](#mod_r) | [float] | `` |
| [mod_pre](#mod_pre) | [float] | `` |
| [mod_post](#mod_post) | [float] | `` |
| [accepted_inputs](#accepted_inputs) | [Array]\[[String]\] | `` |
| [rejected_inputs](#rejected_inputs) | [Array]\[[String]\] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [_init](#_init)(c: [float], r: [float], pre: [float], post: [float], accepted: [Array]\[[String]\], rejected: [Array]\[[String]\] = []) |
| [int] | [check_input](#check_input)(time: [float]) |
| [bool] | [is_lost](#is_lost)(time: [float]) |
| [bool] | [is_early](#is_early)(time: [float]) |
| void | [adjust_with](#adjust_with)(o: [TimeWindow]) |
|  | [clear_mods](#clear_mods)() |

# Enumerations

enum RESULT:
{: #RESULT }
This class represents the interval in which an input can be pressed.<br>
 It's not advised to use them for animations as is, use them in a [TimeWindowController] instead.

 All possible results a [TimeWindow] can return when checked.

> CORRECT = 1
> {: #RESULT.CORRECT }
> > Some input was pressed at the center of a [TimeWindow].

> IGNORED = 0
> {: #RESULT.IGNORED }
> > No relevant input was pressed.

> TOO_LATE = -1
> {: #RESULT.TOO_LATE }
> > Some input was pressed after the center.

> TOO_EARLY = -2
> {: #RESULT.TOO_EARLY }
> > Some input was pressed before the center.

> REJECTED = -3
> {: #RESULT.REJECTED }
> > Some input that was to be avoided was pressed.

> OUTSIDE = -4
> {: #RESULT.OUTSIDE }
> > No relevant input was pressed during the whole [TimeWindow].

# Property Descriptions

[float] center
{: #center }

> Absolute time position (in seconds) of the center of the window.

---

[float] radius
{: #radius }

> Radius of the window (in seconds) in which input is considered correct.
 Must be a positive value.

---

[float] pre_window
{: #pre_window }

> Relative time position (in seconds) of the limit in which the input is considered at all.
 It must be before the center so it must always be a negative value.<br>
 <b>A.K.A.</b> "Left arm".

---

[float] post_window
{: #post_window }

> Relative time position (in seconds) of the limit in which the input is considered at all.
 It must be after the center so it must always be a positive value.<br>
 <b>A.K.A.</b> "Right arm".

---

[float] mod_r
{: #mod_r }

> Modified value of [radius](#radius) after the [TimeWindow] has been adjusted.

---

[float] mod_pre
{: #mod_pre }

> Modified value of [pre_window](#pre_window) after the [TimeWindow] has been adjusted.

---

[float] mod_post
{: #mod_post }

> Modified value of [post_window](#post_window) after the [TimeWindow] has been adjusted.

---

[Array]\[[String]\] accepted_inputs
{: #accepted_inputs }

> The list of input names the window will count as [CORRECT](#RESULT.CORRECT).

---

[Array]\[[String]\] rejected_inputs
{: #rejected_inputs }

> The list of input names the window will count as [REJECTED](#RESULT.REJECTED).

---

# Method Descriptions

 _init(c: [float], r: [float], pre: [float], post: [float], accepted: [Array]\[[String]\], rejected: [Array]\[[String]\] = [])
{: #_init }


---

[int] check_input(time: [float])
{: #check_input }

> Returns a [RESULT](#TimeWindow.RESULT) value.

---

[bool] is_lost(time: [float])
{: #is_lost }

> Returns whether the ```time``` is past the [TimeWindow] range.

---

[bool] is_early(time: [float])
{: #is_early }

> Returns whether the ```time``` has reached the [TimeWindow] range.

---

void adjust_with(o: [TimeWindow])
{: #adjust_with }

> Will adjust both TimeWindows if they are overlaping in any way.<br>
 If only the <b>"arms"</b> are overlaping, a middle point based on each arm's length
 will be used as the new reach of both arms.<br>
 If both <b>centers</b> overlap themselves, a middle point based both radius' lenght
 will be used as their new radius, and each <b>arm</b> of their respective sides will be removed.

---

 clear_mods()
{: #clear_mods }

> Restore the [TimeWindow] to the initial state, without any adjustments done.
 Useful if moving to other channel in a [TimeWindowController].

---

[TimeWindow]: TimeWindow

[TimeWindowController]: /class_reference/TimeWindowController

[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[bool]: https://docs.godotengine.org/en/stable/classes/class_bool.html
[int]: https://docs.godotengine.org/en/stable/classes/class_int.html
[float]: https://docs.godotengine.org/en/stable/classes/class_float.html

