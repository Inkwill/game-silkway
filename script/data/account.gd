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
	#listen_obj(curplayer)
	
func check_storage():
	var path = "user://%s/"%name
	if not ResourceLoader.exists(path + "account.res"):
		var dir = Directory.new()
		if dir.open(path) : dir.make_dir(path)
		var err = ResourceSaver.save(path + "account.res",self)
		if err : 
			push_error("Check storage err : %s, account: %s " % [err, name])
			return self
	var storage = ResourceLoader.load(path + "account.res")	
	if not ResourceLoader.exists(path + "world.res"): 
		var err = ResourceSaver.save(path+"world.res",world)
		if err : 
			push_error("Check storage err : %s, world of account: %s " % [err, name])
			return storage
	storage.world = ResourceLoader.load(path+"world.res")
	return storage

func load_player():
	gameManager.storeager.file_name = "user://%s/"%name + "player.res"
	var data = gameManager.storeager.load_json()
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
	print("Save player : %s" % saveplayer("user://%s/"%name  + "player.res"))
	print("Save world : %s" % ResourceSaver.save(world.resource_path,world))
	print("Save account: %s" % ResourceSaver.save(resource_path,self))

func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed)%s(%s: %s -> %s) " % [obj,property,old,new])

func saveplayer(filepath):
	gameManager.storeager.file_name = filepath
	var data = gameManager.storeager.load_json()
	if data is Dictionary: 
		data[curplayer.name] = curplayer.savedata()
		gameManager.storeager.store_json(data)
	else:
		gameManager.storeager.store_json({curplayer.name: curplayer.savedata()})
	return curplayer

func loadplayer(filepath):
	gameManager.storeager.file_name = filepath
	var data = gameManager.storeager.load_json(filepath)
	if data is Dictionary: 
		if curplayer.name in data : curplayer.loaddata(data[curplayer.name])
		else: push_error("No player_data of %s from %s " % [curplayer,filepath])
	else : push_error("Load data erro : %s to %s from %s" % [data,curplayer,filepath])
