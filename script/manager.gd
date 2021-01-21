extends Object
class_name Manager

var members := {}
var savers := []
var db_list := []
var gamedb
var type
var init_data := {}

func _init(_type):
	type = _type
	gamedb = GameDB.new().gb
	gamedb.query("SELECT id from %s;" % type)
	for data in gamedb.query_result:
		db_list.append(data["id"])

func _new_member(_data):
	pass
	
func _storedata(_id):
	pass

func _register(memeber):
	members[memeber.id] = memeber
	var err = memeber.connect("_s_gameobj_changed",self,"_on_member_changed")
	if err : push_warning("Register memeber err[%s] of %s" % [err,memeber])

func _on_member_changed(member,fun,dic):
	if not member.id in savers :savers.append(member.id)
#	print("get signal(member_changed) %s: %s -> %s) " % [member,fun,dic])

func create_member(id=null):
	var _data = init_data
	if id == null :
		gamedb.insert_rows(type, [_data])
		gamedb.query("SELECT id from %s ORDER BY id DESC LIMIT 1;" % type)
		_data["id"] = gamedb.query_result[0]["id"]
	elif id in db_list :
		push_error("Create gameobj err : id[%s] conflict"%id)
		return null
	else :
		_data["id"]=id
		gamedb.insert_rows(type, [_data])
	db_list.append(_data["id"])
	var member = _new_member(_data)
	_register(member)
	return member
	
func get_member(id):
	if id in members.keys() : return members[id]
	if id in db_list:
		var member = _new_member(gamedb.select_rows(type, "id == %s"%id,GameDB.get_columns(type))[0])
		_register(member)
		return member
	else:
		push_warning("Try to get a invalid gameobj: id=%s, type=%s"% [id,type])
		return null

func store_member() :
	if savers.size() == 0 :return 0
	var num := 0
	for id in savers:
		if gamedb.update_rows(type, "id = %s"%id,_storedata(id)):	
			num +=1
	return num
