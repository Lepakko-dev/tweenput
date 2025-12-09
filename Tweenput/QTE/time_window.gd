class_name TimeWindow
## This class represents the interval in which an input can be pressed.[br]
## It's not advised to use them for animations as is, use them in a [TimeWindowController] instead.

## All possible results a [TimeWindow] can return when checked.
enum RESULT{
	CORRECT=1,		## Some input was pressed at the center of a [TimeWindow].
	IGNORED=0,		## No relevant input was pressed.
	TOO_LATE=-1,	## Some input was pressed after the center.
	TOO_EARLY=-2,	## Some input was pressed before the center.
	REJECTED=-3,	## Some input that was to be avoided was pressed.
	OUTSIDE=-4		## No relevant input was pressed during the whole [TimeWindow].
};

## Absolute time position (in seconds) of the center of the window.
var center : float;
## Radius of the window (in seconds) in which input is considered correct.
## Must be a positive value.
var radius : float;
## Relative time position (in seconds) of the limit in which the input is considered at all.
## It must be before the center so it must always be a negative value.[br]
## [b]A.K.A.[/b] "Left arm".
var pre_window : float;
## Relative time position (in seconds) of the limit in which the input is considered at all.
## It must be after the center so it must always be a positive value.[br]
## [b]A.K.A.[/b] "Right arm".
var post_window : float;

## Modified value of [member radius] after the [TimeWindow] has been adjusted.
var mod_r : float;
## Modified value of [member pre_window] after the [TimeWindow] has been adjusted.
var mod_pre : float;
## Modified value of [member post_window] after the [TimeWindow] has been adjusted.
var mod_post : float;

## The list of input names the window will count as [constant CORRECT].
var accepted_inputs : Array[String];
## The list of input names the window will count as [constant REJECTED].
var rejected_inputs : Array[String];


func _init(c:float,r:float,pre:float,post:float,accepted:Array[String],rejected:Array[String]=[]):
	center =c;
	radius = absf(r);
	pre_window = minf(pre,0.);
	post_window = maxf(post,0.);
	accepted_inputs = accepted; 
	rejected_inputs = rejected;

	mod_r = radius;
	mod_pre = pre_window;
	mod_post = post_window;


## Returns a [enum RESULT] value.
func check_input(time:float) -> int:
	if is_early(time): return RESULT.OUTSIDE;
	if is_lost(time): return RESULT.OUTSIDE;
	
	for input_action in accepted_inputs:
		if Input.is_action_just_pressed(input_action):
			if time < (center - mod_r): return RESULT.TOO_EARLY;
			if time > (center + mod_r): return RESULT.TOO_LATE;
			return RESULT.CORRECT;
	
	for input_action in rejected_inputs:
		if Input.is_action_just_pressed(input_action):
			return RESULT.REJECTED;
	return RESULT.IGNORED;

## Returns whether the [param time] is past the [TimeWindow] range.
func is_lost(time:float) -> bool:
	return time > (center + mod_r + mod_post);

## Returns whether the [param time] has reached the [TimeWindow] range.
func is_early(time:float) -> bool:
	return time < (center - mod_r + mod_pre);

## Will adjust both TimeWindows if they are overlaping in any way.[br]
## If only the [b]"arms"[/b] are overlaping, a middle point based on each arm's length
## will be used as the new reach of both arms.[br]
## If both [b]centers[/b] overlap themselves, a middle point based both radius' lenght
## will be used as their new radius, and each [b]arm[/b] of their respective sides will be removed.
func adjust_with(o:TimeWindow) -> void:
	var r1 := center+post_window;
	var r2 := o.center+o.post_window;
	var l1 := center+pre_window;
	var l2 := o.center+o.pre_window;
	if r1 < l2 or r2 < l1: return;
	# At this point there MUST be some kind of collision.
	var center_diff := absf(center - o.center);
	var coll_diff : float = center_diff - radius - o.radius;
	# Find middle point
	if coll_diff < 0: # Worst case. Windows are overlapping => Resize windows :(
		if center < o.center:
			mod_post = 0;
			o.mod_pre = 0;
			var mean := ( minf(center+radius, o.center) + maxf(o.center-radius, center) ) / 2.
			mod_r = mean - center;
			o.mod_r = o.center - mean;
		else:
			mod_pre = 0;
			o.mod_post = 0;
			var mean := ( minf(o.center+o.radius, center) + maxf(center-radius, o.center) ) / 2.
			o.mod_r = mean - o.center;
			mod_r = center - mean;
	else: # Limits are overlapping => Just move limits
		if center < o.center:
			r1=minf(r1,o.center-o.radius);
			l2=maxf(l2,center+radius);
			var mean = (r1+l2)/2;
			mod_post = mean;
			o.mod_pre = mean;
		else:
			l1=minf(l1,center+radius);
			r2=maxf(r2,o.center-o.radius);
			var mean = (l1+r2)/2;
			mod_pre = mean;
			o.mod_post = mean;

## Restore the [TimeWindow] to the initial state, without any adjustments done.
## Useful if moving to other channel in a [TimeWindowController].
func clear_mods():
	mod_r = radius;
	mod_pre = pre_window;
	mod_post = post_window;
