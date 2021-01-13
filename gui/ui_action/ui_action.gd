extends Control
class_name UIAction

enum STATE {READY,OPTION,CONFIRM}
var _state
var _drag_instance
var action
var options := []

func _ready():
	$button.set_drag_forwarding(self)
	fresh(STATE.READY)

func fresh(state):
	match state :
		STATE.READY:
			$button.text = action._data.name
			$lb.text = ""
			$button.rect_scale = Vector2(1,1)
			for elment in $opt.get_children():
				elment.queue_free()
		STATE.OPTION:
			$button.rect_scale = Vector2(0.001,0.001)
			$lb.text = action._data.prompt1
			var option = UIActOption.new(3)
			option.rect_size = Vector2(32,32)
			option.connect("_on_drop",self,"_on_option_droped")
			$opt.add_child(option)
		STATE.CONFIRM:
			$button.rect_scale = Vector2(1,1)
			$button.text = "OK?"
	_state = state

func get_drag_data_fw(_position,_from):
	if _state == STATE.OPTION :	
		_drag_instance = Label.new()
		_drag_instance.text = $button.text
		_drag_instance.rect_size = Vector2(32,32)
		set_drag_preview(_drag_instance)
		return _drag_instance.text

func can_drop_data(_position, _data):
	return true

func drop_data(_position,_data):
	if _state == STATE.OPTION :	
		fresh(STATE.READY)
	
func _on_bt_down():
	if _state == STATE.READY :
		fresh(STATE.OPTION)

func _on_bt_up():
	if _state == STATE.OPTION :	
		fresh(STATE.READY)
		
func _on_option_droped(opt):
	if _state == STATE.OPTION :
		options.append(opt)
		$lb.text = opt._data.name + action._data.name
		fresh(STATE.CONFIRM)

func _on_button_pressed():
	if _state == STATE.CONFIRM :
		action.act(options)
		queue_free()
		
#func _on_ui_action_mouse_exited():
#	if get_viewport().gui_is_dragging():
#		print("drag exited area")
#		$button.text = _drag_instance.text
#		_drag_instance.text = ""
	#_end_drag()
