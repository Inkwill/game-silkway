extends Object
class_name GameDB

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const create_file = "res://resouce/database.json"
var account
var db

func _init(p_account):
	account = p_account
	db = SQLite.new()
	db.path = "user://%s/data.db"%account.name
	db.verbose_mode = true

static func create_db(name):
	var _db = SQLite.new()
	_db.path = "user://%s/data.db"%name
	_db.verbose_mode = true
	_db.import_from_json(create_file)
	_db.query("SELECT * FROM action ;")
	print(str(_db.query_result))
	_db.close_db()
	
