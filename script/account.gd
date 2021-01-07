extends Resource
class_name Account

export(String) var name
export(int) var curday : = 0
export(Array) var player_list := []
var curplayer = null
var asseter = null
var world = null
var actorer = null

func _init(p_name = "",p_world = null,p_players = []):
	name = p_name
	world = p_world
	player_list = p_players
	
func start():
	asseter = Asseter.new()
	world = GameWorld.new()
	actorer = Actorer.new()
	curplayer = actorer.get_member(player_list[0]) if player_list.size() > 0 else actorer.create_member()
	print("game start : account = %s, player = %s, day = %s" % [name,curplayer,curday])
	player_list.append(curplayer.id)

func quit_game():
	print("Save player %s" % actorer._save_member())
	print("Save account %s: %s" % [resource_path,ResourceSaver.save(resource_path,self)])
	print("Save assts num = %s" % asseter._save_member())
	asseter.gamedb.close_db()
	actorer.gamedb.close_db()
	
