class_name TimeWindowController
## Offers a way to handle multiple [TimeWindow] using channels. [br]

## A single timeline where multiple [TimeWindow] are laid and made sure none overlap.
class Channel:
	## Sorted list of TimeWindows (by time).
	var tw_list: Array[TimeWindow];
	## Index of the last valid TW (TWs behind this one won't be check anymore).
	var last_valid: int;
	## Stores the result of every TimeWindow of the [variable Channel.tw_list].
	var results_list: Array[int];
	## Reach of the last TimeWindow in this channel.
	var channel_end: float;

	## Emitted when at least one TimeWindow has been invalidated (has settled with a result)
	signal processed;

	## Inserts the given TimeWindow in a list ordered by their center's time.
	func add_tw(tw: TimeWindow):
		var upper_limit := tw.center + tw.post_window;
		var inserted := false;
		for i in tw_list.size():
			var o := tw_list[i];
			if upper_limit < o.center + o.pre_window:
				tw.adjust_with(o);
				if i > 0: tw.adjust_with(tw_list[i - 1]);
				tw_list.insert(i, tw);
				results_list.insert(i, TimeWindow.RESULT.IGNORED);
				inserted = true;
				break ;
		if not inserted:
			if tw_list.size() > 0:
				tw.adjust_with(tw_list.back());
			tw_list.append(tw);
			results_list.append(TimeWindow.RESULT.IGNORED);
			channel_end = upper_limit;
	
	func clear_list():
		tw_list.clear();
		channel_end = 0;
		results_list.clear();
		last_valid = 0;
	
	func reset_time():
		last_valid = 0;
		for i in results_list.size():
			results_list[i] = TimeWindow.RESULT.IGNORED;
	
	## Tries to get the result of every valid TW until the given timestamp. Time cannot recede.
	## If you want to check a previous time, call [method Channel.reset_time] previously.
	func check_input(time: float):
		var did_process := false;
		for i in range(last_valid, tw_list.size()):
			var tw := tw_list[i];
			if tw.is_early(time): break ;
			
			var res := tw.check_input(time);
			results_list[i] = res;
			if res == TimeWindow.RESULT.IGNORED: # Must listen again next check.
				break ;
			did_process = true;
			if res != TimeWindow.RESULT.OUTSIDE: # Consumed (correct/rejected/too_xxxx)
				last_valid = i + 1;
				break ;
		if did_process: processed.emit();
	
	func get_last_processed_value() -> int:
		if last_valid < 1: return TimeWindow.RESULT.IGNORED;
		return results_list[last_valid - 1];

var _channels: Dictionary[int, Channel];

## Adds the given [TimeWindow] to the specified [TimeWindowController.Channel]
func add_tw(tw: TimeWindow, channel: int = 0):
	_channels.get_or_add(channel, Channel.new()).add_tw(tw);

## Remove all [TimeWindow]s of each channel.
func clear_channels():
	for c in _channels.values():
		c.clear_list();

## Resets time and results of each channel.
func reset_channels():
	for c in _channels.values():
		c.reset_time();

## Returns the channel's reference of the given index.
func get_channel(idx: int) -> Channel:
	return _channels.get(idx, null);


## Checks input against the corresponding [TimeWindow]s in each channel.[br][br]
## - [param time]: The time to check against in the timeline of each channel.
## This value cannot be less than other previously checked times. [br][br]
## See also [method TimeWindowController.Channel.check_input]
func check_input(time: float):
	for k in _channels:
		_channels[k].check_input(time);
