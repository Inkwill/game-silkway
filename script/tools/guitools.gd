extends Object
class_name GUITools

static func set_rect_full(control):
	control.anchor_right = 1
	control.anchor_bottom = 1
	control.margin_right = 0
	control.margin_left = 0

static func	tween_postion(target,from,to,duration =1,callback=null):
	var tw
	if target.has_node("tween"):tw = target.get_node("tween")
	else: 
		tw = Tween.new()
		tw.name = "tween"
		target.add_child(tw)
	var pos_name = "rect_position" if target is Control else "position"
	tw.interpolate_property(target,pos_name,from,to,duration,Tween.TRANS_QUINT, Tween.EASE_OUT)
	if callback != null : tw.interpolate_deferred_callback(target,duration,callback)
	if not tw.is_active():tw.start()
	return tw

static func	tween_color(target,from,to,duration =1,callback=null):
	var tw
	if target.has_node("tween"): tw = target.get_node("tween")
	else: 
		tw = Tween.new()
		tw.name = "tween"
		target.add_child(tw)
	var cr = ColorRect.new()
	cr.add_child(tw)
	set_rect_full(cr)
	
	tw.interpolate_property(cr,"color",from,to,duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if callback != null : tw.interpolate_deferred_callback(target,duration,callback)
	if not tw.is_active():tw.start()
	return tw


static func message(message,duration=1,wide=480):
	var uimes = PopupPanel.new()
	uimes.name = "messageBox"
	uimes.margin_right = wide
	var uilabel = Label.new()
	uilabel.text = str(message)
	uilabel.margin_right = wide
	uilabel.autowrap = true

	uimes.add_child(uilabel)
	host.root.add_child(uimes)
	uimes.popup()
	tween_postion(uimes,Vector2(0,-1*uimes.rect_size.y),Vector2(0,0),duration)
	yield(host.tree.create_timer(1+duration),"timeout")
	tween_postion(uimes,uimes.rect_position,Vector2(0,-1*uimes.rect_size.y),duration)
	yield(host.tree.create_timer(duration),"timeout")
	uimes.queue_free()
