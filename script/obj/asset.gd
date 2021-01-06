extends Object
class_name Asset

var id
var data := {}

func _init(_data):
	data = _data
	id = data["id"]
	
func _to_string() -> String:
	return "asset[%s]: %s "%[id,data]

func add(key,value):
	data[key] += value
