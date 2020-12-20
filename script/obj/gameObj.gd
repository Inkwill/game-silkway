extends Object

class_name GameObj

var name:String setget _set_name
signal _s_gameobj_changed

func _init(_name):
	name = _name

func _set_name(value):
	emit_signal("_s_gameobj_changed",self,"name",name,value)
	name = value
	
func savedata():
	return {}

