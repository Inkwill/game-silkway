extends GameObj

class_name GamePlayer 

var gold:int setget _set_gold

func _init(_name).(_name):
	gold = 10
	
func _set_gold(value):
	print("emit_signal(%s): set gold %s-> %s" % [self,gold,value])
	emit_signal("_s_gameobj_changed",self,"gold",gold,value)
	gold = value

func _to_string() -> String:
	return "%s[GamePlayer:%s]"%[name,get_instance_id()]

func savedata():
	return {"name":name, "gold":gold}
	
func loaddata(data):
	gold = data["gold"]
