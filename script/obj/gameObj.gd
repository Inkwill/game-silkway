extends Object
class_name GameObj

signal _s_gameobj_changed

var ownerid
var id:int
var type:String
var data := {}
var pos := Vector2(0,0) setget _set_pos


func _init(_data,_type):
	type = _type
	data = _data
	_init_properties(["id","ownerid","form","createdate","perishdate"])
	pos = Vector2(_data["posx"],_data["posy"])
	
func _to_string() -> String:
	return "gobj_%s[%s]"%[type,id]

func _set_pos(value:Vector2):
	pos = value
	emit_signal("_s_gameobj_changed",self,"set_pos",value)

func _init_properties(names):
	for name in names:
		if name in data : set(name,data[name])
