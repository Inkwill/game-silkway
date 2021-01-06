extends Resource
class_name Account

export(String) var name
export(Font) var font_normal
export(Resource) var world
export(Array) var player_list := []

var curplayer = null
var assets_manager = null

func _init(p_name = "",p_font_normal = null,p_world = null,p_players = []):
	name = p_name
	font_normal = p_font_normal
	world = p_world
	player_list = p_players
	
func start():
	assets_manager = AssetsManager.new()
	load_player()
	world.start()
	#listen_obj(curplayer)
	
func load_player():
	curplayer = GamePlayer.new()
	if player_list.size() > 0 :	curplayer.load_data(player_list[0])
	else: 
		curplayer.register_data()
		player_list.append(curplayer.id)

func listen_obj(obj:GameObj):
	var err = obj.connect("_s_gameobj_changed",self,"_on_gameobj_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_gameobj_changed",obj])
	
func quit_game():
	print("Save player %s" % curplayer.save_data())
	print("Save world %s: %s" % [world.resource_path,ResourceSaver.save(world.resource_path,world)])
	print("Save account %s: %s" % [resource_path,ResourceSaver.save(resource_path,self)])

func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed)%s(%s: %s -> %s) " % [obj,property,old,new])
