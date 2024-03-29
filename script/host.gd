extends Node

onready var tree = get_tree()
onready var root = get_tree().root
var account = preload("res://resouce/storage/account.res")
var storager = preload("res://addons/storage-manager/storager.res").instance()
const db_file = "res://resouce/database.res"
const startpos := Vector2(109,34) # 長安
const begin := {"year":-220,"month":11,"day":14,"hour":12} # 秦始皇帝 二十七年 辛巳年 十月 一日 1641025
const end := {"year":266,"month":2,"day":8,"hour":12} # 西晉武帝 泰始元年 乙酉年 十二月 十七日 1818253
const startDate := {"year":-140,"month":11,"day":01,"hour":12} # 西漢武帝 建元元年 辛丑年 十月 一日 午時 1670231

var aero_data = GameTable.new("res://resouce/data/aero.res")


var res_loader

func _ready():
	if storager.bind(account) == OK: 
		storager.load_storage()
		account.start()
	else : 
		creat_account()
		account.start(true)
	
func creat_account():
	print("****Create account****")
	storager.creat_storage()
	print("creat storage completed!")
	GameDB.new().create_db(db_file)
	print("creat db completed!")
	account.curday = GameDate.get_juliandate(startDate)
	print("****Create account completed****")

func goto_scene(path):
	res_loader = load("res://gui/ui_res_loader/res_loader.tscn").instance()
	GUITools.tween_color(root,Color(0,0,0,0),Color(0,0,0,1),5)
	root.add_child(res_loader)
	res_loader.connect("_load_finished",self,"_on_loader_finished")
	res_loader.call_deferred("load_res",path)

func _on_loader_finished(resource):
	# Free current scene.
	tree.current_scene.queue_free()
	tree.current_scene = null
	# Wait a moment
	yield(tree.create_timer(0.1),"timeout")
	var new_scene = resource.instance()
	# Add new one to root.
	tree.root.add_child(new_scene)
	# Set as current scene.
	tree.current_scene = new_scene
	res_loader.queue_free()
	GUITools.tween_color(root,Color(0,0,0,1),Color(0,0,0,0),5)

func _exit_tree():
	account.quit_game()
	
