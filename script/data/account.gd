extends Resource
class_name Account

export(String) var name
export(String) var player_name
export(Font) var font_normal
export(Resource) var world

var curplayer = null
var player_list := []

func _init(p_name = "",p_player_name = "",p_font_normal = null,p_world = null):
	name = p_name
	player_name = p_player_name
	font_normal = p_font_normal
	world = p_world
	
func start():
	load_player()
	world.start()
	#world.curDate = GameDate.get_juliandate(world.startDate) if world.curDate == 0 else world.curDate
	#listen_obj(curplayer)
	
func load_player():
	var data = GameLoader.load_json("user://%s/"%name + "player.res")
	if data is Dictionary: player_list = data.keys()
	if player_name in player_list : 
		curplayer = GamePlayer.new(player_name)
		curplayer.loaddata(data[player_name])
	else: create_new_player(player_name)

func create_new_player(p_name):
	curplayer = GamePlayer.new(p_name)
	
func listen_obj(obj:GameObj):
	var err = obj.connect("_s_gameobj_changed",self,"_on_gameobj_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_gameobj_changed",obj])
	
func quit_game():
	print("Save player : %s" % GameSaver.saveplayer(curplayer,"user://%s/"%name  + "player.res"))
	print("Save world : %s" % ResourceSaver.save(world.resource_path,world))
	print("Save account: %s" % ResourceSaver.save(resource_path,self))

func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed)%s(%s: %s -> %s) " % [obj,property,old,new])
