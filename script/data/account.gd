extends Resource
class_name Account

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
	load_player_list()
	print(player_name)
	if player_name in player_list : load_player(player_name)
	else : create_new_player(player_name)
	listen_player(curplayer)

func load_player_list():
	var data = GameLoader.load_json(save_path + "player.save")
	player_list = data.keys() if data is Dictionary else []
#	if data is Dictionary: return data.keys()
#	else: return 
	
func check_save_dir():
	var dir = Directory.new()
	if dir.open(save_path) : dir.make_dir(save_path)

func create_new_player(p_name):
	curplayer = GamePlayer.new(p_name)
	
func load_player(p_name):
	curplayer = GamePlayer.new(p_name)
	GameLoader.load_player(curplayer, save_path + "player.save")

func listen_player(player:GamePlayer):
	var err = player.connect("_s_gameobj_changed",self,"_on_gameobj_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_gameobj_changed",player])
	player_list.append(player.name)
	
func quit_game():
	print("Save player : %s" % GameSaver.saveplayer(curplayer,save_path  + "player.save"))
	print("Save account: %s" % ResourceSaver.save(resource_path,self))
	
func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed)%s(%s: %s -> %s) " % [obj,property,old,new])
