extends Resource
class_name Account

export(String) var name
export(Font) var font_normal
export(Array, String) var strings

var _save_path :String
var savefiles := []
var player_list:= []
var current_player = null

func _init(p_name = "",p_font_normal = null, p_strings = []):
	name = p_name
	font_normal = p_font_normal
	strings = p_strings
	
func start():
	_save_path = "user://%s/" % name
	var dir = Directory.new()
	if dir.open(_save_path) == OK:
		savefiles = GameLoader.dir_contents(_save_path)["file"]
	else: dir.make_dir(_save_path)	
		
	current_player = GamePlayer.new("player01")
	add_player(current_player)
	var file = "player.save"
	if file in savefiles : GameLoader.load_player(current_player, _save_path + file)
	else : push_warning("Can't find savefile : %s from %s" % [file,_save_path])

func add_player(player:GamePlayer):
	var err = player.connect("_s_gameobj_changed",self,"_on_gameobj_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_gameobj_changed",player])
	else: player_list.append(player)

func quit_game():
	print("Save player : %s" % GameSaver.saveplayer(player_list,_save_path  + "player.save"))

func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed)%s(%s: %s -> %s) " % [obj,property,old,new])
