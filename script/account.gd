extends Resource
class_name Account

export(String) var name
export(float) var curday : = 0.0
export(Array) var player_list := []
export(Font) var normal_font

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
	actorer = Actorer.new()
	curplayer = actorer.get_member(player_list[0]) if player_list.size() > 0 else actorer.create_member()
	print("game start : account = %s, player = %s, day = %s" % [name,curplayer,curday])
	player_list.append(curplayer.id)
	world = GameWorld.new()

func quit_game():
	print("Save player num = %s" % actorer.store_member())
	print("Save account %s: %s (0==OK)" % [resource_path,ResourceSaver.save(resource_path,self)])
	print("Save assets num = %s" % asseter.store_member())
	print("Save aero num = %s" % world.store_member())
	asseter.gamedb.close_db()
	actorer.gamedb.close_db()
	world.gamedb.close_db()
	
