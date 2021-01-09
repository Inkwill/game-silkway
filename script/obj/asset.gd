extends GameObj
class_name Asset

static func load_asset(_id):
	return host.account.asseter.get_member(_id)

func _init(_data,_type = "asset").(_data,_type):
	pass
	
func _to_string() -> String:
	return "asset[%s]: %s "%[id,data]

func add(dic):
	var num := 0
	for key in dic:
		if key in data.keys() :
			data[key] += int(dic[key])
			num += 1
	if num : emit_signal("_s_gameobj_changed",self,"add",dic)
	return num == dic.size()
