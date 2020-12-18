extends GameObj

class_name GamePlayer 

var gold:int setget _set_gold

func _init():
	gold = 10
	name = "inkwill"
	var save_game = File.new()
	if save_game.file_exists("user://%s.save"% name):
		save_game.open("user://%s.save"% name,File.READ)
		var save_data = parse_json(save_game.get_line())
		gold = save_data["gold"]

func _set_gold(value):
	print("emit_signal: set gold %s-> %s" % [gold,value])
	emit_signal("_s_gameobj_changed","gold",gold,value)
	gold = value

func _to_string():
	return "%s[GamePlayer:%s]"%[name,get_instance_id()]
