---
layout: default-title
title: TimeWindowController
parent: Class Reference
has_toc: false
---

Offers a way to handle multiple [TimeWindow] using channels. <br>

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_channels](#_channels) | [Dictionary]\[[int], [Channel]\] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [add_tw](#add_tw)(tw: [TimeWindow], channel: [int] = 0) |
|  | [clear_channels](#clear_channels)() |
|  | [reset_channels](#reset_channels)() |
| [Channel] | [get_channel](#get_channel)(idx: [int]) |
|  | [check_input](#check_input)(time: [float]) |

# Inner Classes

- [Channel]

# Property Descriptions

[Dictionary]\[[int], [Channel]\] _channels
{: #_channels }


---

# Method Descriptions

 add_tw(tw: [TimeWindow], channel: [int] = 0)
{: #add_tw }

> Adds the given [TimeWindow] to the specified [TimeWindowController.Channel]

---

 clear_channels()
{: #clear_channels }

> Remove all [TimeWindow]s of each channel.

---

 reset_channels()
{: #reset_channels }

> Resets time and results of each channel.

---

[Channel] get_channel(idx: [int])
{: #get_channel }

> Returns the channel's reference of the given index.

---

 check_input(time: [float])
{: #check_input }

> Checks input against the corresponding [TimeWindow]s in each channel.<br><br>
 - ```time```: The time to check against in the timeline of each channel.
 This value cannot be less than other previously checked times. <br><br>
 See also [TimeWindowController.Channel.check_input()][TimeWindowController.Channel#check_input]

---

[TimeWindowController]: TimeWindowController
[Channel]: Channel

[TimeWindowController.Channel.check_input]: /class_reference/TimeWindowController/Channel/check_input
[TimeWindow]: /class_reference/TimeWindow

[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[int]: https://docs.godotengine.org/en/stable/classes/class_int.html
[float]: https://docs.godotengine.org/en/stable/classes/class_float.html

