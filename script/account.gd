extends Resource
class_name Account

export(String) var name 
export(float) var curday 
export(Array) var player_list := [] 

var player = null setget _private_setter
var asseter = null setget _private_setter
var world = null setget _private_setter
var actorer = null setget _private_setter
var date = null setget _private_setter

func _init(p_name = "",p_players = []):
	name = p_name
	player_list = p_players
	
func start():
	date = GameDate.new()
	world = GameWorld.new()
	asseter = Asseter.new()
	actorer = Actorer.new()
	player = actorer.get_member(player_list[0]) if player_list.size() > 0 else actorer.create_member()
	print("game start : account = %s, player = %s, day = %s" % [name,player,curday])
	player_list.append(player.id)

func quit_game():
	print("Save player num = %s" % actorer.store_member())
	print("Save account %s: %s (0==OK)" % [resource_path,ResourceSaver.save(resource_path,self)])
	print("Save assets num = %s" % asseter.store_member())
	print("Save aero num = %s" % world.store_member())
	asseter.gamedb.close_db()
	actorer.gamedb.close_db()
	world.gamedb.close_db()
	
func _private_setter(_value):
	push_warning("Illegal operation : _private_setter to Account![name:%s,set_value:] "% [name._value])
