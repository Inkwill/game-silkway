extends Object
class_name Asset

var id
var data := {}
var save := false

signal _s_asset_changed

func _init(_data):
	data = _data
	id = data["id"]
	
func _to_string() -> String:
	return "asset[%s]: %s "%[id,data]

func add(dic):
	var num := 0
	for key in dic:
		if key in data.keys() :
			data[key] += int(dic[key])
			num += 1
	save = num > 0
	if save : emit_signal("_s_asset_changed",self,"add",dic)
	return num == dic.size()
