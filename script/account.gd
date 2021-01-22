extends Resource
class_name Account

export(String) var name 
export(float) var curday setget _curday_setter
export(Array) var player_list := [] 

var player = null setget _private_setter
var asseter = null setget _private_setter
var world = null setget _private_setter
var actorer = null setget _private_setter
var date = null setget _private_setter

func _init(p_name = "",p_curday = 0.0,p_players = []):
	name = p_name
	player_list = p_players
	curday = p_curday
	
func start():
	date = GameDate.new()
	world = GameWorld.new()
	asseter = Asseter.new()
	actorer = Actorer.new()
	print("game start : account = %s, player_list = %s, day = %s" % [name,player_list,curday])
	if player_list.size() > 0 : player = actorer.get_member(player_list[0])
	else : 
		player = actorer.create_member()
		player_list.append(player.id)
	print("player start : name = %s, action_num = %s" % [player.name,player.action_list.size()])
	if player.action_list.size() > 0 : player.act()

func quit_game():
	date.is_running = false
	print("Save aero num = %s" % world.store_member())
	print("Save assets num = %s" % asseter.store_member())
	print("Save player num = %s" % actorer.store_member())
	print("Save account at %s: %s (0==OK)" % [curday,ResourceSaver.save(resource_path,self)])
	world.gamedb.close_db()
	asseter.gamedb.close_db()
	actorer.gamedb.close_db()
	
func _private_setter(_value):
	push_warning("Illegal operation : _private_setter to Account![name:%s,set_value:] "% [name._value])

func _curday_setter(_value):
#	push_warning("curday %s -> %s" % [curday, _value])
	curday = _value
