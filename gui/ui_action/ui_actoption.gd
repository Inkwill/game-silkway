extends Button
class_name UIActOption

signal _on_drop
var _action

func _init(id):
	_action = Action.new(id)
	text = _action._data.name

func can_drop_data(_position, _data):
	return _data is String

func drop_data(_position,_data):
	text += _data
	print("on drop data")
	
