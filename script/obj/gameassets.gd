extends Object
class_name GameAssets

var id
var data := {}

func _init(_data):
	data = _data
	id = data["id"]
	
func _to_string() -> String:
	return "asset[%s]: %s "%[id,data]
