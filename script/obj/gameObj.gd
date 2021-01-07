extends Object
class_name GameObj

var id setget _private_setter
var type:String setget _private_setter
var data := {} setget _private_setter


func _init(_data,_type):
	id = _data["id"]
	type = _type
	data = _data
	
func _to_string() -> String:
	return "gobj_%s[%s]"%[type,id]

func _private_setter(_value):
	push_warning("Illegal operation : _private_setter to GameObj![%s -> %s] "% [_value,self])
