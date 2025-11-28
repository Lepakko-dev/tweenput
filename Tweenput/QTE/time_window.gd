class_name TimeWindow
## For Item animations
## This class represents the interval in which an input can be pressed.
## It's not advised to use them for animations manually, use its manager instead.


const CORRECT   := 1;
const IGNORED   := 0;
const TOO_LATE  := -1;
const TOO_EARLY := -2;
const REJECTED := -3;
const OUTSIDE   := -4;

## Absolute position in time (in seconds) of the center of the window.
var center : float;
## Radius of the window (in seconds) in which input is considered correct.
## Must be a positive value.
var radius : float;
## Relative position in time (in seconds) of the limit in which the input is considered at all.
## It must be before the center so it will always be a negative value.
var pre_window : float;
## Relative position in time (in seconds) of the limit in which the input is considered at all.
## It must be after the center so it will always be a positive value.
var post_window : float;

var mod_r : float; 
var mod_pre : float; 
var mod_post : float;

## The list of input names the window will consider.
var accepted_inputs : Array[String];
## The list og input names the window will count as invalid. 
## If the input neither accepted nor rejected, it will be ignored.
var rejected_inputs : Array[String];
## If true, will reject all inputs that are not accepted (no input will be ignored).
var reject_any : bool;


func _init(c:float,r:float,pre:float,post:float,accepted:Array[String],rejected:Array[String]=[],reject:bool=false):
	center =c;
	radius = absf(r);
	pre_window = minf(pre,0.);
	post_window = maxf(post,0.);
	accepted_inputs = accepted; 
	reject_any = reject;
	rejected_inputs = rejected;

	mod_r = radius;
	mod_pre = pre_window;
	mod_post = post_window;


## Will return any of the status constants of the class.
## ([constant TimeWindow.CORRECT], [constant TimeWindow.TOO_EARLY], [constant TimeWindow.TOO_LATE], 
## [constant TimeWindow.OUTSIDE], [constant TimeWindow.IGNORED], [constant TimeWindow.REJECTED])
func check_input(time:float, input:String) -> int:
	
	if time < (center + mod_pre): return OUTSIDE;
	if time > (center + mod_post): return OUTSIDE;
	
	if not accepted_inputs.has(input):
		if rejected_inputs.has(input) or reject_any:
			return REJECTED;
		else:
			return IGNORED;
	
	if time < (center - mod_r): return TOO_EARLY;
	if time > (center + mod_r): return TOO_LATE;

	return CORRECT;

func is_lost(time:float):
	return time > (center + mod_post);


## Will adjust both TimeWindows if they are colliding in any way
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

## Restore the TW to the initial state, without any adjustments done.
## Useful if moving to other channel in its manager.
func clear_mods():
	mod_r = radius;
	mod_pre = pre_window;
	mod_post = post_window;
