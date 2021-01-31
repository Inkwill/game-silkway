extends Resource
class_name Account

export(String) var name 
export(float) var curday setget _curday_setter
export(Array) var incident_list :=[]
export(Array) var player_list := [] 

var player = null setget _private_setter
var asseter = null setget _private_setter
var aeroer = null setget _private_setter
var actorer = null setget _private_setter
var date = null setget _private_setter
var dynastyer = null setget _private_setter
var incident = null setget _private_setter

func _init(p_name = "",p_curday = 0.0,p_incident_list = [],p_players = []):
	name = p_name
	player_list = p_players
	curday = p_curday
	incident_list = p_incident_list
	
func start():
	date = GameDate.new()
	aeroer = Aeroer.new()
	asseter = Asseter.new()
	dynastyer = Dynastyer.new()
	actorer = Actorer.new()
	print("*** Game start : account = %s, player_list = %s, day = %s" % [name,player_list,curday])
	if player_list.size() > 0 : player = actorer.get_member(player_list[0])
	else : 
		player = actorer.create_member()
		player_list.append(player.id)
	print("*** Player start : name = %s, action_num = %s" % [player.name,player.action_list.size()])
	if player.action_list.size() > 0 : player.act()
	print("*** Incident start,produced:%s" % [incident_list])
	incident = Incident.new()
	incident.check()

func quit_game():
	date.is_running = false
	print("*** Save actor num = %s" % actorer.store_member())
	print("*** Save dynasty num = %s" % dynastyer.store_member())
	print("*** Save assets num = %s" % asseter.store_member())
	print("*** Save aero num = %s" % aeroer.store_member())
	print("*** Save account at %s: %s (0==OK)" % [curday,ResourceSaver.save(resource_path,self)])
	aeroer.gamedb.close_db()
	asseter.gamedb.close_db()
	actorer.gamedb.close_db()
	dynastyer.gamedb.close_db()
	
func _private_setter(_value):
	push_warning("Illegal operation : _private_setter to Account![name:%s,set_value:] "% [name._value])

func _curday_setter(_value):
#	push_warning("curday %s -> %s" % [curday, _value])
	curday = _value
