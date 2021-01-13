extends Button
class_name UIActOption

signal _on_drop
var _opt

func _init(id):
	_opt = ActOption.new(id)
	text = _opt._data.name

func can_drop_data(_position, data):
	return data is String

func drop_data(_position,data):
	text += data
	emit_signal("_on_drop",_opt)
	print("on drop option:%s"%_opt._data)
	queue_free()
