extends Object

class_name GameObj

var id 
var type
var name:String setget _set_name
var owner
var assets

signal _s_gameobj_changed

func _init(_type):
	type = _type
	
func _set_name(value):
	name = value
	var gb = GameDB.get_db()
	if gb.update_rows("gameobj", "id = %s"%id, {"name":name}):
		emit_signal("_s_gameobj_changed",self,"name",name,value)
	gb.close_db()
	
func _to_string() -> String:
	return "gobj_%s[name:%s,id:%s]"%[type,name,id]
	
func register_data():
	name = gameManager.account.name
	var gb = GameDB.get_db()
	gb.insert_rows("gameobj", [{"type": type, "name": name}])
	gb.query("SELECT id from gameobj ORDER BY id DESC LIMIT 1;")
	id = gb.query_result[0]["id"]
	assets = [{"owner": id, "coin": 1000,"silver":100,"gold":1}]
	gb.insert_rows("assets", assets)
	gb.close_db()
	
func load_data(_id):
	var gb = GameDB.get_db()
	id = _id
	var data = gb.select_rows("gameobj", "id == %s and type == '%s' "% [id,type], ["name","owner"])[0]
	name = data["name"]
	owner = data["owner"]
	assets = gb.select_rows("assets", "owner == %s"%id, ["id","owner","coin","silver","gold"])
	print(assets)
	gb.close_db()

func save_data():
	var gb = GameDB.get_db()
	gb.update_rows("gameobj", "id = %s"%id, {"owner":owner})
	gb.close_db()
	return self
