class_name TimeWindowController
## Offers a way to handle TimeWindows in multi-channel.

class Channel:
	## Sorted lists of TimeWindows.
	var tw_list : Array[TimeWindow];
	## Index of the last valid TimeWindow (TWs behind the time of the last check are invalidated).
	var last_valid :int;
	## Stores the result of every TimeWindow of the [variable Channel.tw_list]
	var results_list : Array[int];
	
	var channel_end : float;

	func add_tw(tw:TimeWindow):
		var upper_limit := tw.center + tw.post_window;
		var inserted := false;
		for i in tw_list.size():
			var o := tw_list[i];
			if upper_limit < o.center + o.pre_window:
				tw.adjust_with(o);
				if i > 0: tw.adjust_with(tw_list[i-1]);
				tw_list.insert(i,tw);
				inserted = true;
				break;
		if not inserted:
			tw.adjust_with(tw_list.back());
			tw_list.append(tw);
			channel_end = upper_limit;
		results_list.resize(tw_list.size()); # New default values are TimeWindow.IGNORED (0)
	
	func clear_list():
		tw_list.clear();
		channel_end = 0;
		results_list.clear();
		last_valid = 0;
	
	func reset_time():
		last_valid = 0;
		for i in results_list.size():
			results_list[i] = TimeWindow.IGNORED;
	
	func check_input(time:float, input:String):
		for i in range(last_valid,tw_list.size()):
			var tw := tw_list[i];
			if not tw.is_lost(time):
				results_list[i] = tw.check_input(time,input);
				last_valid = i;
				break;

var _channels : Dictionary[int,Channel];

func add_tw(tw:TimeWindow,channel:int=0):
	_channels.get_or_add(channel,Channel.new()).add_tw(tw);

func clear_channels():
	for c in _channels.values():
		c.clear_list();

func reset_channels():
	for c in _channels.values():
		c.reset_time();

func get_channel(idx:int) -> Channel:
	return _channels.get(idx,null);


## Checks input against the corresponding TWs in each channel
func check_input(time:float, input:String):
	for k in _channels:
		_channels[k].check_input(time,input);
