extends Object
class_name GameDB

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const create_file = "res://resouce/database.res"
#func _init(p_account):
#	account = p_account
#	db = SQLite.new()
#	db.path = "user://%s/data.db"%account.name
#	db.verbose_mode = true

static func get_db(verbose = true):
	var _db = SQLite.new()
	_db.path = "user://%s/data.db"%gameManager.account.name
	_db.verbose_mode = verbose
	if _db.open_db() : return _db
	else : push_error("Open GameDB erro at : %s"% _db.path)

static func create_db():
	var gb = get_db()
	gb.query("SELECT name FROM sqlite_master WHERE type = 'table';")
	for t in dic_value(gb.query_result,"name"):
		gb.drop_table(t)
	var _tables = gameManager.storager.load_json(create_file)["data"]
	for table in _tables:
		gb.create_table(table,_tables[table])
#		_db.query("PRAGMA table_info(%s);" %table)
#		print(str(_db.query_result))
	gb.close_db()

static func dic_value(array,key):
	var data := []
	for d in array:
		data.append(d[key])
	return data
