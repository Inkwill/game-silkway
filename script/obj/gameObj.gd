extends Object
class_name GameObj

signal _s_gameobj_changed

var id setget _private_setter
var ownerid setget _private_setter
var type:String setget _private_setter
var data := {} setget _private_setter
var pos := Vector2(0,0) setget _set_pos

func _init(_data,_type):
	id = _data["id"]
	ownerid = _data["ownerid"]
	type = _type
	data = _data
	pos = Vector2(_data["posx"],_data["posy"])
	
func _to_string() -> String:
	return "gobj_%s[%s]"%[type,id]

func _private_setter(_value):
	push_warning("Illegal operation : _private_setter to GameObj![%s -> %s] "% [_value,self])

func _set_pos(value:Vector2):
	pos = value
	emit_signal("_s_gameobj_changed",self,"set_pos",value)
