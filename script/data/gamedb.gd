extends Object
class_name GameDB

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var create_file = "res://resouce/database.res"
var dbname = ""
var gdb

func _init(name):
	dbname = name
	
