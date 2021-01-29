extends Node

onready var tree = get_tree()
onready var root = get_tree().root
var account = preload("res://resouce/storage/account.res")
var storager = preload("res://addons/storage-manager/storager.res").instance()
const db_file = "res://resouce/database.res"

var res_loader

func _enter_tree():
	creat_account()

func creat_account():
	if storager.bind(account) == OK: storager.load_storage()
	else : 
		print("****Create account****")
		storager.creat_storage()
		print("creat storage completed!")
		GameDB.new().create_db(db_file)
		print("creat db completed!")
		account.curday = GameDate.get_juliandate(GameDate.startDate)
		print("****Create account completed****")
	account.start()

func goto_scene(path):
	res_loader = load("res://gui/ui_res_loader/res_loader.tscn").instance()
	GUITools.tween_color(root,Color(0,0,0,0),Color(0,0,0,1),1)
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
	GUITools.tween_color(root,Color(0,0,0,1),Color(0,0,0,0),1)

func _exit_tree():
	account.quit_game()
	
