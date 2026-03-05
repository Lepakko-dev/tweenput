---
layout: default-title
title: CoroutineLinks
parent: Tweenterpreter
---

Maps code labels to coroutines ([Callable]) connected to a signal.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [_dict](#_dict) | [Dictionary]\[[String], [Callable]\] | `` |

# Methods

| Return Type | Name |
|:-|:-|
|  | [add](#add)(label: [String], callable: [Callable]) |
|  | [remove](#remove)(label: [String]) |
|  | [clear](#clear)() |
| [Callable] | [get_callable](#get_callable)(label: [String]) |

# Property Descriptions

[Dictionary]\[[String], [Callable]\] _dict
{: #_dict }


---

# Method Descriptions

 add(label: [String], callable: [Callable])
{: #add }


---

 remove(label: [String])
{: #remove }


---

 clear()
{: #clear }


---

[Callable] get_callable(label: [String])
{: #get_callable }


---

[CoroutineLinks]: CoroutineLinks


[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html

