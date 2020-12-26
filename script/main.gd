extends Node2D
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const account = preload("res://resouce/account.tres")

var db
var db_name := "res://resouce/db/chinese_calendar"


export(Font) var font
# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBox.message(account.name)
	$bg/Button.text = account.curplayer.gold as String
	
	db = SQLite.new()
	db.path = db_name
	db.verbose_mode = true
	db.open_db()


func _on_Button_pressed():
	var player = account.curplayer
	player.gold += 1
	#gameManager.current_player.set("gold", gameManager.current_player.gold +1)
	$bg/Button.text = account.curplayer.gold as String

	var select_condition : String = "emperor_id == %s" % account.curplayer.gold
	var selected_array : Array = db.select_rows("t_emperor_names", select_condition, ["name"])
	print("condition: " + select_condition)
	for city in selected_array:
		MessageBox.message(city["name"])
