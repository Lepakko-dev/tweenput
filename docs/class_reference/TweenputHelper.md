---
layout: default-title
title: TweenputHelper
parent: Class Reference
has_toc: false
---

This class solely exist because the Godot Engine doesn't support reflection
 on any [Variant] type that's not an [Object], 
 which means this has to be done manually.

# Properties

| Name | Type | Default |
|:-|:-|:-|
| [constructors](#constructors) | [Dictionary]\[[String], [Callable]\] | `{"Vector2": V2,"Vector2i": V2i,"Rect2": R2,"Rect2i": R2i,"Vector3": V3,"Vector3i": V3i,"AABB": R3,"Color": C,# Implement more here if necessary.}` |
| [string_methods](#string_methods) | [Dictionary]\[[String], [Callable]\] | `{"contains": _contains,"erase": _erase,"find": _find,"insert": _insert,"is_empty": _is_empty,"length": _length,"replace": _replace,"substr": _substr,"to_float": _to_float,"to_int": _to_int,"to_lower": _to_lower,"to_upper": _to_upper,"[]": _string_arr,"[]=": _string_arr_a,}` |
| [vector2_methods](#vector2_methods) | [Dictionary]\[[String], [Callable]\] | `{"angle_to_point": _vec2_angle_to_point,"[]": _vec2_arr,"[]=": _vec2_arr_a,}` |
| [vector2i_methods](#vector2i_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _vec2i_arr,"[]=": _vec2i_arr_a,}` |
| [vector3_methods](#vector3_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _vec3_arr,"[]=": _vec3_arr_a,}` |
| [vector3i_methods](#vector3i_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _vec3i_arr,"[]=": _vec3i_arr_a,}` |
| [vector4_methods](#vector4_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _vec4_arr,"[]=": _vec4_arr_a,}` |
| [vector4i_methods](#vector4i_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _vec4i_arr,"[]=": _vec4i_arr_a,}` |
| [color_methods](#color_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _color_arr,"[]=": _color_arr_a,}` |
| [callable_methods](#callable_methods) | [Dictionary]\[[String], [Callable]\] | `{"bind": _bind,"bindv": _bindv,"call": _call,"callv": _callv,"get_argument_count": _get_arg_count,"is_null": _is_null,"is_valid": _is_valid,"unbound": _unbound,}` |
| [array_methods](#array_methods) | [Dictionary]\[[String], [Callable]\] | `{"append": _array_append,"back": _array_back,"clear": _array_clear,"erase": _array_erase,"find": _array_find,"font": _array_font,"has": _array_has,"insert": _array_insert,"is_empty": _array_is_empty,"pick_random": _array_pick_random,"pop_back": _array_pop_back,"pop_front": _array_pop_front,"remove_at": _array_remove_at,"resize": _array_resize,"shuffle": _array_shuffle,"size": _array_size,"[]": _array_arr,"[]=": _array_arr_a,}` |
| [dict_methods](#dict_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _dict_arr,"[]=": _dict_arr_a,}` |
| [byte_arr_methods](#byte_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pbyte_arr,"[]=": _pbyte_arr_a,}` |
| [int32_arr_methods](#int32_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pint32_arr,"[]=": _pint32_arr_a,}` |
| [int64_arr_methods](#int64_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pint64_arr,"[]=": _pint64_arr_a,}` |
| [float32_arr_methods](#float32_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pfloat32_arr,"[]=": _pfloat32_arr_a,}` |
| [float64_arr_methods](#float64_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pfloat64_arr,"[]=": _pfloat64_arr_a,}` |
| [string_arr_methods](#string_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pstring_arr,"[]=": _pstring_arr_a,}` |
| [vector2_arr_methods](#vector2_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pv2_arr,"[]=": _pv2_arr_a,}` |
| [vector3_arr_methods](#vector3_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pv3_arr,"[]=": _pv3_arr_a,}` |
| [color_arr_methods](#color_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pcolor_arr,"[]=": _pcolor_arr_a,}` |
| [vector4_arr_methods](#vector4_arr_methods) | [Dictionary]\[[String], [Callable]\] | `{"[]": _pv4_arr,"[]=": _pv4_arr_a,}` |
| [variants](#variants) | [Array]\[[Dictionary]\] | `[ # All 38 types of Variant ordered by Variant.TYPE{}, {}, {}, {}, string_methods,vector2_methods, vector2i_methods, {}, {}, vector3_methods,vector3i_methods, {}, vector4_methods, vector4i_methods, {},{}, {}, {}, {}, {},color_methods, {}, {}, {}, {},callable_methods, {}, dict_methods, array_methods, byte_arr_methods,int32_arr_methods, int64_arr_methods, float32_arr_methods, float64_arr_methods, string_arr_methods,vector2_arr_methods, vector3_arr_methods, color_arr_methods, vector4_arr_methods]` |
| [macros](#macros) | [Dictionary]\[[[String]], [[String]]\] | `{"TWEEN_PROCESS_PHYSICS": "0","TWEEN_PROCESS_IDLE": "1","TWEEN_PAUSE_BOUND": "0","TWEEN_PAUSE_STOP": "1","TRANS_LINEAR": "0","TRANS_SINE": "1","TRANS_QUINT": "2","TRANS_QUART": "3","TRANS_QUAD": "4","TRANS_EXPO": "5","TRANS_ELASTIC": "6","TRANS_CUBIC": "7","TRANS_CIRC": "8","TRANS_BOUNCE": "9","TRANS_BACK": "10","TRANS_SPRING": "11","EASE_IN": "0","EASE_OUT": "1","EASE_IN_OUT": "2","EASE_OUT_IN": "3",}` |

# Methods

| Return Type | Name |
|:-|:-|
| [Variant] | [V2](#V2)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [V2i](#V2i)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [R2](#R2)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [R2i](#R2i)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [V3](#V3)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [V3i](#V3i)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [R3](#R3)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [Variant] | [C](#C)(params: [Array]\[[TweenputParser.LangNode]\]) |
| [bool] | [_contains](#_contains)(ref: [String], what: [String]) |
| [String] | [_erase](#_erase)(ref: [String], position: [int], chars: [int] = 1) |
| [int] | [_find](#_find)(ref: [String], what: [String], from: [int] = 0) |
| [String] | [_insert](#_insert)(ref: [String], position: [int], what: [String]) |
| [bool] | [_is_empty](#_is_empty)(ref: [String]) |
| [int] | [_length](#_length)(ref: [String]) |
| [String] | [_replace](#_replace)(ref: [String], what: [String], forwhat: [String]) |
| [String] | [_substr](#_substr)(ref: [String], from: [int], length: [int]) |
| [float] | [_to_float](#_to_float)(ref: [String]) |
| [int] | [_to_int](#_to_int)(ref: [String]) |
| [String] | [_to_lower](#_to_lower)(ref: [String]) |
| [String] | [_to_upper](#_to_upper)(ref: [String]) |
| [String] | [_string_arr](#_string_arr)(ref: [String], idx: [int]) |
|  | [_string_arr_a](#_string_arr_a)(ref: [String], idx: [int], value: [String]) |
| [float] | [_vec2_angle_to_point](#_vec2_angle_to_point)(ref: [Vector2], to: [Vector2]) |
| [float] | [_vec2_arr](#_vec2_arr)(ref: [Vector2], idx: [int]) |
|  | [_vec2_arr_a](#_vec2_arr_a)(ref: [Vector2], idx: [int], val: [float]) |
| [int] | [_vec2i_arr](#_vec2i_arr)(ref: [Vector2i], idx: [int]) |
|  | [_vec2i_arr_a](#_vec2i_arr_a)(ref: [Vector2i], idx: [int], val: [int]) |
| [float] | [_vec3_arr](#_vec3_arr)(ref: [Vector3], idx: [int]) |
|  | [_vec3_arr_a](#_vec3_arr_a)(ref: [Vector3], idx: [int], val: [float]) |
| [int] | [_vec3i_arr](#_vec3i_arr)(ref: [Vector3i], idx: [int]) |
|  | [_vec3i_arr_a](#_vec3i_arr_a)(ref: [Vector3i], idx: [int], val: [int]) |
| [float] | [_vec4_arr](#_vec4_arr)(ref: [Vector4], idx: [int]) |
|  | [_vec4_arr_a](#_vec4_arr_a)(ref: [Vector4], idx: [int], val: [float]) |
| [int] | [_vec4i_arr](#_vec4i_arr)(ref: [Vector4i], idx: [int]) |
|  | [_vec4i_arr_a](#_vec4i_arr_a)(ref: [Vector4i], idx: [int], val: [int]) |
| [float] | [_color_arr](#_color_arr)(ref: [Color], idx: [int]) |
|  | [_color_arr_a](#_color_arr_a)(ref: [Color], idx: [int], val: [float]) |
| [Callable] | [_bind](#_bind)(ref: [Callable]) |
| [Callable] | [_bindv](#_bindv)(ref: [Callable], arg: [Array]) |
| [Variant] | [_call](#_call)(ref: [Callable]) |
| [Variant] | [_callv](#_callv)(ref: [Callable], arg: [Array]) |
| [int] | [_get_arg_count](#_get_arg_count)(ref: [Callable]) |
| [bool] | [_is_null](#_is_null)(ref: [Callable]) |
| [bool] | [_is_valid](#_is_valid)(ref: [Callable]) |
| [Callable] | [_unbound](#_unbound)(ref: [Callable], argcount: [int]) |
|  | [_array_append](#_array_append)(ref: [Array], val: [Variant]) |
| [Variant] | [_array_back](#_array_back)(ref: [Array]) |
|  | [_array_clear](#_array_clear)(ref: [Array]) |
|  | [_array_erase](#_array_erase)(ref: [Array], val: [Variant]) |
| [int] | [_array_find](#_array_find)(ref: [Array], what: [Variant], from: [int] = 0) |
| [Variant] | [_array_font](#_array_font)(ref: [Array]) |
| [bool] | [_array_has](#_array_has)(ref: [Array], val: [Variant]) |
| [int] | [_array_insert](#_array_insert)(ref: [Array], pos: [int], val: [Variant]) |
| [bool] | [_array_is_empty](#_array_is_empty)(ref: [Array]) |
| [Variant] | [_array_pick_random](#_array_pick_random)(ref: [Array]) |
| [Variant] | [_array_pop_back](#_array_pop_back)(ref: [Array]) |
| [Variant] | [_array_pop_front](#_array_pop_front)(ref: [Array]) |
|  | [_array_remove_at](#_array_remove_at)(ref: [Array], pos: [int]) |
| [int] | [_array_resize](#_array_resize)(ref: [Array], size: [int]) |
|  | [_array_shuffle](#_array_shuffle)(ref: [Array]) |
| [int] | [_array_size](#_array_size)(ref: [Array]) |
| [Variant] | [_array_arr](#_array_arr)(ref: [Array], idx: [int]) |
|  | [_array_arr_a](#_array_arr_a)(ref: [Array], idx: [int], val: [Variant]) |
| [Variant] | [_dict_arr](#_dict_arr)(ref: [Dictionary], idx: [Variant]) |
|  | [_dict_arr_a](#_dict_arr_a)(ref: [Dictionary], idx: [Variant], val: [Variant]) |
| [int] | [_pbyte_arr](#_pbyte_arr)(ref: [PackedByteArray], idx: [int]) |
|  | [_pbyte_arr_a](#_pbyte_arr_a)(ref: [PackedByteArray], idx: [int], val: [int]) |
| [int] | [_pint32_arr](#_pint32_arr)(ref: [PackedInt32Array], idx: [int]) |
|  | [_pint32_arr_a](#_pint32_arr_a)(ref: [PackedInt32Array], idx: [int], val: [int]) |
| [int] | [_pint64_arr](#_pint64_arr)(ref: [PackedInt64Array], idx: [int]) |
|  | [_pint64_arr_a](#_pint64_arr_a)(ref: [PackedInt64Array], idx: [int], val: [int]) |
| [float] | [_pfloat32_arr](#_pfloat32_arr)(ref: [PackedFloat32Array], idx: [int]) |
|  | [_pfloat32_arr_a](#_pfloat32_arr_a)(ref: [PackedFloat32Array], idx: [int], val: [float]) |
| [float] | [_pfloat64_arr](#_pfloat64_arr)(ref: [PackedFloat64Array], idx: [int]) |
|  | [_pfloat64_arr_a](#_pfloat64_arr_a)(ref: [PackedFloat64Array], idx: [int], val: [float]) |
| [String] | [_pstring_arr](#_pstring_arr)(ref: [PackedStringArray], idx: [int]) |
|  | [_pstring_arr_a](#_pstring_arr_a)(ref: [PackedStringArray], idx: [int], val: [String]) |
| [Vector2] | [_pv2_arr](#_pv2_arr)(ref: [PackedVector2Array], idx: [int]) |
|  | [_pv2_arr_a](#_pv2_arr_a)(ref: [PackedVector2Array], idx: [int], val: [Vector2]) |
| [Vector3] | [_pv3_arr](#_pv3_arr)(ref: [PackedVector3Array], idx: [int]) |
|  | [_pv3_arr_a](#_pv3_arr_a)(ref: [PackedVector3Array], idx: [int], val: [Vector3]) |
| [Color] | [_pcolor_arr](#_pcolor_arr)(ref: [PackedColorArray], idx: [int]) |
|  | [_pcolor_arr_a](#_pcolor_arr_a)(ref: [PackedColorArray], idx: [int], val: [Color]) |
| [Vector4] | [_pv4_arr](#_pv4_arr)(ref: [PackedVector4Array], idx: [int]) |
|  | [_pv4_arr_a](#_pv4_arr_a)(ref: [PackedVector4Array], idx: [int], val: [Vector4]) |
| [Callable] | [construct](#construct)(type: [String]) |
| [Callable] | [reflect](#reflect)(obj: [Variant], method: [String]) |
| [String] | [get_macro](#get_macro)(macro: [String]) |

# Property Descriptions

static [Dictionary]\[[String], [Callable]\] constructors = ```{"Vector2": V2,"Vector2i": V2i,"Rect2": R2,"Rect2i": R2i,"Vector3": V3,"Vector3i": V3i,"AABB": R3,"Color": C,# Implement more here if necessary.}```
{: #constructors }


---

static [Dictionary]\[[String], [Callable]\] string_methods = ```{"contains": _contains,"erase": _erase,"find": _find,"insert": _insert,"is_empty": _is_empty,"length": _length,"replace": _replace,"substr": _substr,"to_float": _to_float,"to_int": _to_int,"to_lower": _to_lower,"to_upper": _to_upper,"[]": _string_arr,"[]=": _string_arr_a,}```
{: #string_methods }


---

static [Dictionary]\[[String], [Callable]\] vector2_methods = ```{"angle_to_point": _vec2_angle_to_point,"[]": _vec2_arr,"[]=": _vec2_arr_a,}```
{: #vector2_methods }


---

static [Dictionary]\[[String], [Callable]\] vector2i_methods = ```{"[]": _vec2i_arr,"[]=": _vec2i_arr_a,}```
{: #vector2i_methods }


---

static [Dictionary]\[[String], [Callable]\] vector3_methods = ```{"[]": _vec3_arr,"[]=": _vec3_arr_a,}```
{: #vector3_methods }


---

static [Dictionary]\[[String], [Callable]\] vector3i_methods = ```{"[]": _vec3i_arr,"[]=": _vec3i_arr_a,}```
{: #vector3i_methods }


---

static [Dictionary]\[[String], [Callable]\] vector4_methods = ```{"[]": _vec4_arr,"[]=": _vec4_arr_a,}```
{: #vector4_methods }


---

static [Dictionary]\[[String], [Callable]\] vector4i_methods = ```{"[]": _vec4i_arr,"[]=": _vec4i_arr_a,}```
{: #vector4i_methods }


---

static [Dictionary]\[[String], [Callable]\] color_methods = ```{"[]": _color_arr,"[]=": _color_arr_a,}```
{: #color_methods }


---

static [Dictionary]\[[String], [Callable]\] callable_methods = ```{"bind": _bind,"bindv": _bindv,"call": _call,"callv": _callv,"get_argument_count": _get_arg_count,"is_null": _is_null,"is_valid": _is_valid,"unbound": _unbound,}```
{: #callable_methods }


---

static [Dictionary]\[[String], [Callable]\] array_methods = ```{"append": _array_append,"back": _array_back,"clear": _array_clear,"erase": _array_erase,"find": _array_find,"font": _array_font,"has": _array_has,"insert": _array_insert,"is_empty": _array_is_empty,"pick_random": _array_pick_random,"pop_back": _array_pop_back,"pop_front": _array_pop_front,"remove_at": _array_remove_at,"resize": _array_resize,"shuffle": _array_shuffle,"size": _array_size,"[]": _array_arr,"[]=": _array_arr_a,}```
{: #array_methods }


---

static [Dictionary]\[[String], [Callable]\] dict_methods = ```{"[]": _dict_arr,"[]=": _dict_arr_a,}```
{: #dict_methods }


---

static [Dictionary]\[[String], [Callable]\] byte_arr_methods = ```{"[]": _pbyte_arr,"[]=": _pbyte_arr_a,}```
{: #byte_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] int32_arr_methods = ```{"[]": _pint32_arr,"[]=": _pint32_arr_a,}```
{: #int32_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] int64_arr_methods = ```{"[]": _pint64_arr,"[]=": _pint64_arr_a,}```
{: #int64_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] float32_arr_methods = ```{"[]": _pfloat32_arr,"[]=": _pfloat32_arr_a,}```
{: #float32_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] float64_arr_methods = ```{"[]": _pfloat64_arr,"[]=": _pfloat64_arr_a,}```
{: #float64_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] string_arr_methods = ```{"[]": _pstring_arr,"[]=": _pstring_arr_a,}```
{: #string_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] vector2_arr_methods = ```{"[]": _pv2_arr,"[]=": _pv2_arr_a,}```
{: #vector2_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] vector3_arr_methods = ```{"[]": _pv3_arr,"[]=": _pv3_arr_a,}```
{: #vector3_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] color_arr_methods = ```{"[]": _pcolor_arr,"[]=": _pcolor_arr_a,}```
{: #color_arr_methods }


---

static [Dictionary]\[[String], [Callable]\] vector4_arr_methods = ```{"[]": _pv4_arr,"[]=": _pv4_arr_a,}```
{: #vector4_arr_methods }


---

static [Array]\[[Dictionary]\] variants = ```[ # All 38 types of Variant ordered by Variant.TYPE{}, {}, {}, {}, string_methods,vector2_methods, vector2i_methods, {}, {}, vector3_methods,vector3i_methods, {}, vector4_methods, vector4i_methods, {},{}, {}, {}, {}, {},color_methods, {}, {}, {}, {},callable_methods, {}, dict_methods, array_methods, byte_arr_methods,int32_arr_methods, int64_arr_methods, float32_arr_methods, float64_arr_methods, string_arr_methods,vector2_arr_methods, vector3_arr_methods, color_arr_methods, vector4_arr_methods]```
{: #variants }


---

static [Dictionary]\[[[String]], [[String]]\] macros = ```{"TWEEN_PROCESS_PHYSICS": "0","TWEEN_PROCESS_IDLE": "1","TWEEN_PAUSE_BOUND": "0","TWEEN_PAUSE_STOP": "1","TRANS_LINEAR": "0","TRANS_SINE": "1","TRANS_QUINT": "2","TRANS_QUART": "3","TRANS_QUAD": "4","TRANS_EXPO": "5","TRANS_ELASTIC": "6","TRANS_CUBIC": "7","TRANS_CIRC": "8","TRANS_BOUNCE": "9","TRANS_BACK": "10","TRANS_SPRING": "11","EASE_IN": "0","EASE_OUT": "1","EASE_IN_OUT": "2","EASE_OUT_IN": "3",}```
{: #macros }


---

# Method Descriptions

static [Variant] V2(params: [Array]\[[TweenputParser.LangNode]\])
{: #V2 }


---

static [Variant] V2i(params: [Array]\[[TweenputParser.LangNode]\])
{: #V2i }


---

static [Variant] R2(params: [Array]\[[TweenputParser.LangNode]\])
{: #R2 }


---

static [Variant] R2i(params: [Array]\[[TweenputParser.LangNode]\])
{: #R2i }


---

static [Variant] V3(params: [Array]\[[TweenputParser.LangNode]\])
{: #V3 }


---

static [Variant] V3i(params: [Array]\[[TweenputParser.LangNode]\])
{: #V3i }


---

static [Variant] R3(params: [Array]\[[TweenputParser.LangNode]\])
{: #R3 }


---

static [Variant] C(params: [Array]\[[TweenputParser.LangNode]\])
{: #C }


---

static [bool] _contains(ref: [String], what: [String])
{: #_contains }


---

static [String] _erase(ref: [String], position: [int], chars: [int] = 1)
{: #_erase }


---

static [int] _find(ref: [String], what: [String], from: [int] = 0)
{: #_find }


---

static [String] _insert(ref: [String], position: [int], what: [String])
{: #_insert }


---

static [bool] _is_empty(ref: [String])
{: #_is_empty }


---

static [int] _length(ref: [String])
{: #_length }


---

static [String] _replace(ref: [String], what: [String], forwhat: [String])
{: #_replace }


---

static [String] _substr(ref: [String], from: [int], length: [int])
{: #_substr }


---

static [float] _to_float(ref: [String])
{: #_to_float }


---

static [int] _to_int(ref: [String])
{: #_to_int }


---

static [String] _to_lower(ref: [String])
{: #_to_lower }


---

static [String] _to_upper(ref: [String])
{: #_to_upper }


---

static [String] _string_arr(ref: [String], idx: [int])
{: #_string_arr }


---

static  _string_arr_a(ref: [String], idx: [int], value: [String])
{: #_string_arr_a }


---

static [float] _vec2_angle_to_point(ref: [Vector2], to: [Vector2])
{: #_vec2_angle_to_point }


---

static [float] _vec2_arr(ref: [Vector2], idx: [int])
{: #_vec2_arr }


---

static  _vec2_arr_a(ref: [Vector2], idx: [int], val: [float])
{: #_vec2_arr_a }


---

static [int] _vec2i_arr(ref: [Vector2i], idx: [int])
{: #_vec2i_arr }


---

static  _vec2i_arr_a(ref: [Vector2i], idx: [int], val: [int])
{: #_vec2i_arr_a }


---

static [float] _vec3_arr(ref: [Vector3], idx: [int])
{: #_vec3_arr }


---

static  _vec3_arr_a(ref: [Vector3], idx: [int], val: [float])
{: #_vec3_arr_a }


---

static [int] _vec3i_arr(ref: [Vector3i], idx: [int])
{: #_vec3i_arr }


---

static  _vec3i_arr_a(ref: [Vector3i], idx: [int], val: [int])
{: #_vec3i_arr_a }


---

static [float] _vec4_arr(ref: [Vector4], idx: [int])
{: #_vec4_arr }


---

static  _vec4_arr_a(ref: [Vector4], idx: [int], val: [float])
{: #_vec4_arr_a }


---

static [int] _vec4i_arr(ref: [Vector4i], idx: [int])
{: #_vec4i_arr }


---

static  _vec4i_arr_a(ref: [Vector4i], idx: [int], val: [int])
{: #_vec4i_arr_a }


---

static [float] _color_arr(ref: [Color], idx: [int])
{: #_color_arr }


---

static  _color_arr_a(ref: [Color], idx: [int], val: [float])
{: #_color_arr_a }


---

static [Callable] _bind(ref: [Callable])
{: #_bind }


---

static [Callable] _bindv(ref: [Callable], arg: [Array])
{: #_bindv }


---

static [Variant] _call(ref: [Callable])
{: #_call }


---

static [Variant] _callv(ref: [Callable], arg: [Array])
{: #_callv }


---

static [int] _get_arg_count(ref: [Callable])
{: #_get_arg_count }


---

static [bool] _is_null(ref: [Callable])
{: #_is_null }


---

static [bool] _is_valid(ref: [Callable])
{: #_is_valid }


---

static [Callable] _unbound(ref: [Callable], argcount: [int])
{: #_unbound }


---

static  _array_append(ref: [Array], val: [Variant])
{: #_array_append }


---

static [Variant] _array_back(ref: [Array])
{: #_array_back }


---

static  _array_clear(ref: [Array])
{: #_array_clear }


---

static  _array_erase(ref: [Array], val: [Variant])
{: #_array_erase }


---

static [int] _array_find(ref: [Array], what: [Variant], from: [int] = 0)
{: #_array_find }


---

static [Variant] _array_font(ref: [Array])
{: #_array_font }


---

static [bool] _array_has(ref: [Array], val: [Variant])
{: #_array_has }


---

static [int] _array_insert(ref: [Array], pos: [int], val: [Variant])
{: #_array_insert }


---

static [bool] _array_is_empty(ref: [Array])
{: #_array_is_empty }


---

static [Variant] _array_pick_random(ref: [Array])
{: #_array_pick_random }


---

static [Variant] _array_pop_back(ref: [Array])
{: #_array_pop_back }


---

static [Variant] _array_pop_front(ref: [Array])
{: #_array_pop_front }


---

static  _array_remove_at(ref: [Array], pos: [int])
{: #_array_remove_at }


---

static [int] _array_resize(ref: [Array], size: [int])
{: #_array_resize }


---

static  _array_shuffle(ref: [Array])
{: #_array_shuffle }


---

static [int] _array_size(ref: [Array])
{: #_array_size }


---

static [Variant] _array_arr(ref: [Array], idx: [int])
{: #_array_arr }


---

static  _array_arr_a(ref: [Array], idx: [int], val: [Variant])
{: #_array_arr_a }


---

static [Variant] _dict_arr(ref: [Dictionary], idx: [Variant])
{: #_dict_arr }


---

static  _dict_arr_a(ref: [Dictionary], idx: [Variant], val: [Variant])
{: #_dict_arr_a }


---

static [int] _pbyte_arr(ref: [PackedByteArray], idx: [int])
{: #_pbyte_arr }


---

static  _pbyte_arr_a(ref: [PackedByteArray], idx: [int], val: [int])
{: #_pbyte_arr_a }


---

static [int] _pint32_arr(ref: [PackedInt32Array], idx: [int])
{: #_pint32_arr }


---

static  _pint32_arr_a(ref: [PackedInt32Array], idx: [int], val: [int])
{: #_pint32_arr_a }


---

static [int] _pint64_arr(ref: [PackedInt64Array], idx: [int])
{: #_pint64_arr }


---

static  _pint64_arr_a(ref: [PackedInt64Array], idx: [int], val: [int])
{: #_pint64_arr_a }


---

static [float] _pfloat32_arr(ref: [PackedFloat32Array], idx: [int])
{: #_pfloat32_arr }


---

static  _pfloat32_arr_a(ref: [PackedFloat32Array], idx: [int], val: [float])
{: #_pfloat32_arr_a }


---

static [float] _pfloat64_arr(ref: [PackedFloat64Array], idx: [int])
{: #_pfloat64_arr }


---

static  _pfloat64_arr_a(ref: [PackedFloat64Array], idx: [int], val: [float])
{: #_pfloat64_arr_a }


---

static [String] _pstring_arr(ref: [PackedStringArray], idx: [int])
{: #_pstring_arr }


---

static  _pstring_arr_a(ref: [PackedStringArray], idx: [int], val: [String])
{: #_pstring_arr_a }


---

static [Vector2] _pv2_arr(ref: [PackedVector2Array], idx: [int])
{: #_pv2_arr }


---

static  _pv2_arr_a(ref: [PackedVector2Array], idx: [int], val: [Vector2])
{: #_pv2_arr_a }


---

static [Vector3] _pv3_arr(ref: [PackedVector3Array], idx: [int])
{: #_pv3_arr }


---

static  _pv3_arr_a(ref: [PackedVector3Array], idx: [int], val: [Vector3])
{: #_pv3_arr_a }


---

static [Color] _pcolor_arr(ref: [PackedColorArray], idx: [int])
{: #_pcolor_arr }


---

static  _pcolor_arr_a(ref: [PackedColorArray], idx: [int], val: [Color])
{: #_pcolor_arr_a }


---

static [Vector4] _pv4_arr(ref: [PackedVector4Array], idx: [int])
{: #_pv4_arr }


---

static  _pv4_arr_a(ref: [PackedVector4Array], idx: [int], val: [Vector4])
{: #_pv4_arr_a }


---

static [Callable] construct(type: [String])
{: #construct }


---

static [Callable] reflect(obj: [Variant], method: [String])
{: #reflect }


---

static [String] get_macro(macro: [String])
{: #get_macro }


---

[TweenputHelper]: TweenputHelper

[TweenputParser.LangNode]: /class_reference/TweenputParser/LangNode

[Dictionary]: https://docs.godotengine.org/en/stable/classes/class_dictionary.html
[String]: https://docs.godotengine.org/en/stable/classes/class_string.html
[Callable]: https://docs.godotengine.org/en/stable/classes/class_callable.html
[Array]: https://docs.godotengine.org/en/stable/classes/class_array.html
[Variant]: https://docs.godotengine.org/en/stable/classes/class_variant.html
[bool]: https://docs.godotengine.org/en/stable/classes/class_bool.html
[int]: https://docs.godotengine.org/en/stable/classes/class_int.html
[float]: https://docs.godotengine.org/en/stable/classes/class_float.html
[Vector2]: https://docs.godotengine.org/en/stable/classes/class_vector2.html
[Vector2i]: https://docs.godotengine.org/en/stable/classes/class_vector2i.html
[Vector3]: https://docs.godotengine.org/en/stable/classes/class_vector3.html
[Vector3i]: https://docs.godotengine.org/en/stable/classes/class_vector3i.html
[Vector4]: https://docs.godotengine.org/en/stable/classes/class_vector4.html
[Vector4i]: https://docs.godotengine.org/en/stable/classes/class_vector4i.html
[Color]: https://docs.godotengine.org/en/stable/classes/class_color.html
[Object]: https://docs.godotengine.org/en/stable/classes/class_object.html
[PackedByteArray]: https://docs.godotengine.org/en/stable/classes/class_packedbytearray.html
[PackedInt32Array]: https://docs.godotengine.org/en/stable/classes/class_packedint32array.html
[PackedInt64Array]: https://docs.godotengine.org/en/stable/classes/class_packedint64array.html
[PackedFloat32Array]: https://docs.godotengine.org/en/stable/classes/class_packedfloat32array.html
[PackedFloat64Array]: https://docs.godotengine.org/en/stable/classes/class_packedfloat64array.html
[PackedStringArray]: https://docs.godotengine.org/en/stable/classes/class_packedstringarray.html
[PackedVector2Array]: https://docs.godotengine.org/en/stable/classes/class_packedvector2array.html
[PackedVector3Array]: https://docs.godotengine.org/en/stable/classes/class_packedvector3array.html
[PackedVector4Array]: https://docs.godotengine.org/en/stable/classes/class_packedvector4array.html
[PackedColorArray]: https://docs.godotengine.org/en/stable/classes/class_packedcolorarray.html

