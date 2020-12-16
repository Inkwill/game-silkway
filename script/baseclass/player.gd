extends Object

class_name Player 

var gold:int
var name:String

func _init():
	gold = 10
	name = "inkwill"
	var save_game = File.new()
	if save_game.file_exists("user://%s.save"%name):
		print("load OK!")
		save_game.open("user://%s.save"%name,File.READ)
		var save_data = parse_json(save_game.get_line())
		gold = save_data["gold"]


