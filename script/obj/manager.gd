extends Object
class_name Manager

var members := {} #{id:gameobj}
var savers := [] #gameobj
var db_list := [] #int
var gamedb
var type
var form

func _init(_form,_type):
	type = _type
	form = _form
	gamedb = GameDB.new().gb
	gamedb.query("SELECT id from %s WHERE perishdate == -1 AND form == '%s';" % [type,form])
#	var datas = gamedb.select_rows(type, "form = %s"%form, ["id"])
	for data in gamedb.query_result:
		db_list.append(data["id"])

func _init_data(_id=null):
	return {"posx":host.startpos.x,"posy":host.startpos.y,"form":form, "ownerid": null,"createdate":int(host.account.curday),"perishdate":-1}

func _new_member(_data):
	pass
	
func _storedata(_id):
	pass

func _register(memeber):
	members[memeber.id] = memeber
	var err = memeber.connect("_s_gameobj_changed",self,"_on_member_changed")
	if err : push_warning("Register memeber err[%s] of %s" % [err,memeber])

func _on_member_changed(member,key,old,new):
	if not member.id in savers :savers.append(member.id)
	print("Set %s %s : %s->%s " % [member,key,old,new])

func create_member(id=null):
	var _data = _init_data(id)
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
	var member = _new_member(_data)
	_register(member)
	db_list.append(_data["id"])
	return member
	
func get_member(dic:Dictionary):
	if "id" in dic and dic.id in members: return members[dic.id]
	var select_condition = "form == '%s'"%form
	for key in dic:
		select_condition = select_condition + " AND " + "%s == '%s'"%[key,dic[key]] if dic[key] is String else "%s == %s"%[key,dic[key]]
#	printerr("select_condition:%s"%[select_condition])
	var selected_array = gamedb.select_rows(type, select_condition,["*"]) #GameDB.get_columns(type))
	if selected_array.size() > 0 :
		if selected_array.size() > 1 : push_warning("get_member selected more than one result:%s"%[dic])
		var member = _new_member(selected_array[0])
		_register(member)
		return member
	else: push_warning("Try to get a invalid gameobj: %s"% [dic])
	return null

func store_member() :
	if savers.size() == 0 :return 0
	var num := 0
	for id in savers:
		if gamedb.update_rows(type, "id = %s"%id,_storedata(id)):	
			num +=1
	return num
