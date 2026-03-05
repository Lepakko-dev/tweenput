---
layout: default-title
title: Channel
parent: TimeWindowController
---

A single timeline where multiple [TimeWindow] are laid and made sure none overlap.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [tw_list](#tw_list) | [Array]\[[TimeWindow]\] | `` |
| [last_valid](#last_valid) | [int] | `` |
| [results_list](#results_list) | [Array]\[[int]\] | `` |
| [channel_end](#channel_end) | [float] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [add_tw](#add_tw)(tw: [TimeWindow]) |
|  | [clear_list](#clear_list)() |
|  | [reset_time](#reset_time)() |
|  | [check_input](#check_input)(time: [float]) |
| [int] | [get_last_processed_value](#get_last_processed_value)() |

# Signals

processed()
: Emitted when at least one TimeWindow has been invalidated (has settled with a result)

# Property Descriptions

[Array]\[[TimeWindow]\] tw_list
{: #tw_list }

> Sorted list of TimeWindows (by time).

---

[int] last_valid
{: #last_valid }

> Index of the last valid TW (TWs behind this one won't be check anymore).

---

[Array]\[[int]\] results_list
{: #results_list }

> Stores the result of every TimeWindow of the [Channel.tw_list](#tw_list).

---

[float] channel_end
{: #channel_end }

> Reach of the last TimeWindow in this channel.

---

# Method Descriptions

 add_tw(tw: [TimeWindow])
{: #add_tw }

> Inserts the given TimeWindow in a list ordered by their center's time.

---

 clear_list()
{: #clear_list }


---

 reset_time()
{: #reset_time }


---

 check_input(time: [float])
{: #check_input }

> Tries to get the result of every valid TW until the given timestamp. Time cannot recede.
 If you want to check a previous time, call [Channel.reset_time](#reset_time) previously.

---

[int] get_last_processed_value()
{: #get_last_processed_value }


---

[Channel]: Channel

[TimeWindow]: /class_reference/TimeWindow

[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[int]: https://docs.godotengine.org/en/stable/classes/class_int.html
[float]: https://docs.godotengine.org/en/stable/classes/class_float.html

