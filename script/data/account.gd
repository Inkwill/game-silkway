extends Resource
class_name Account

const world = preload("res://resouce/world.tres")

export(String) var name
export(String) var player_name
export(String) var save_path
export(Font) var font_normal

var curplayer = null
var player_list := []

func _init(p_name = "",p_player_name = "", p_save_path = "",p_font_normal = null):
	name = p_name
	player_name = p_player_name
	save_path = p_save_path
	font_normal = p_font_normal
	
func start():
	check_save_dir()
	load_player()
	world.curDate = GameWorld.get_juliandate(world.startDate)
	#listen_obj(curplayer)
	
func load_player():
	var data = GameLoader.load_json(save_path + "player.save")
	if data is Dictionary: player_list = data.keys()
	if player_name in player_list : 
		curplayer = GamePlayer.new(player_name)
		curplayer.loaddata(data[player_name])
	else: create_new_player(player_name)
		
func check_save_dir():
	var dir = Directory.new()
	if dir.open(save_path) : dir.make_dir(save_path)

func create_new_player(p_name):
	curplayer = GamePlayer.new(p_name)
	
func listen_obj(obj:GameObj):
	var err = obj.connect("_s_gameobj_changed",self,"_on_gameobj_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_gameobj_changed",obj])
	
func quit_game():
	print("Save player : %s" % GameSaver.saveplayer(curplayer,save_path  + "player.save"))
	print("Save account: %s" % ResourceSaver.save(resource_path,self))
	
func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed)%s(%s: %s -> %s) " % [obj,property,old,new])
