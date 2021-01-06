extends Object

class_name GameObj

var id 
var type
var name:String setget _set_name
var owner
var asset

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

func own(someth):
	someth.owner = id

func carry_asset() -> GameAssets:
	return gameManager.account.assets_manager.get_asset(asset)

func register_data():
	name = gameManager.account.name
	var gb = GameDB.get_db()
	gb.insert_rows("gameobj", [{"type": type, "name": name}])
	gb.query("SELECT id from gameobj ORDER BY id DESC LIMIT 1;")
	id = gb.query_result[0]["id"]
	gb.close_db()
	
func load_data(_id):
	var gb = GameDB.get_db()
	id = _id
	var data = gb.select_rows("gameobj", "id == %s and type == '%s' "% [id,type], ["name","owner","asset"])[0]
	name = data["name"]
	owner = data["owner"]
	asset = data["asset"]
	gb.close_db()

func save_data():
	var gb = GameDB.get_db()
	gb.update_rows("gameobj", "id = %s"%id, {"owner":owner,"asset":asset})
	gb.close_db()
	return self
