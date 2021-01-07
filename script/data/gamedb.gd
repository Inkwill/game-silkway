extends Object
class_name GameDB

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var gb

func _init():
	gb = SQLite.new()
	gb.path = "user://%s/data.db"%host.account.name
	gb.verbose_mode = false
	if not gb.open_db() : push_error("Open GameDB erro at : %s"% gb.path)

func create_db(file):
	gb.query("SELECT name FROM sqlite_master WHERE type = 'table';")
	for t in dic_value(gb.query_result,"name"):
		gb.drop_table(t)
	var _tables = host.storager.load_json(file)["data"]
	for table in _tables:
		gb.create_table(table,_tables[table])
#		_db.query("PRAGMA table_info(%s);" %table)
#		print(str(_db.query_result))
	gb.close_db()

func dic_value(array,key):
	var data := []
	for d in array:
		data.append(d[key])
	return data
