extends GameObj

class_name GamePlayer 

var gold:int setget _set_gold

func _init():
	gold = 10
	name = "inkwill"
	var data = Loader.load_from_file("user://%s.save"% name)
	if data is Dictionary:	gold = data["gold"]
	else : push_error("Load data err : %s of %s" % [data, self])
	

func _set_gold(value):
	print("emit_signal: set gold %s-> %s" % [gold,value])
	emit_signal("_s_gameobj_changed",self,"gold",gold,value)
	gold = value

func _to_string() -> String:
	return "%s[GamePlayer:%s]"%[name,get_instance_id()]

func _savedata():
	return {"name":name, "gold":gold}
	
func save():
	return Saver.save_to_file(_savedata(),"user://%s.save"%name)
