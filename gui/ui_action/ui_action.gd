extends Control
class_name UIAction


var _drag_instance
var action
var _option

func _ready():
	$button.text = action._data.name
	$button.set_drag_forwarding(self)
	
func get_drag_data_fw(_position,_from):
	_drag_instance = Label.new()
	_drag_instance.text = $button.text
	_drag_instance.rect_size = Vector2(32,32)
#	_drag_instance.font = host.account.normal_font
	set_drag_preview(_drag_instance)
	return _drag_instance.text

func can_drop_data(_position, _data):
	return true

func can_drop_data_fw(_position, _data,_from):
	return true
	
func drop_data_fw(_position, _data,_from):
	print("on drop data fw")
	if _from == _option:
		_option.text += _data

func drop_data(_position,_data):
	print("on drop data")
	$button.rect_scale = Vector2(1,1)
	_option.free()
	
func _on_bt_down():
	$button.rect_scale = Vector2(0.001,0.001)
	_option = UIActOption.new(3)
	_option.rect_size = Vector2(32,32)
#	_option.set_drag_forwarding(self)
	$opt.add_child(_option)
#	rect_size = get_viewport().size
#	print("set size:%s"%rect_size)
	
func _on_bt_up():
	$button.rect_scale = Vector2(1,1)
	_option.free()
#	rect_size = Vector2(1,1)
#func next(value):
#	for id in value.split(","):
#		print(id)
#	var bt = $button_action.instance()
#	bt._action = Action.new(_base_action._actor,2)
#	bt.rect_size = Vector2(30,20)
#	bt.set_position(Vector2(0,10))
#	add_child(bt)


#func _on_ui_action_mouse_exited():
#	if get_viewport().gui_is_dragging():
#		print("drag exited area")
#		$button.text = _drag_instance.text
#		_drag_instance.text = ""
	#_end_drag()
