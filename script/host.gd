extends Node

onready var root = get_tree().root
var res_loader = preload("res://gui/ui_res_loader/res_loader.tscn").instance()
var account = preload("res://resouce/storage/account.res")
var storager = preload("res://addons/storage-manager/storager.res").instance()
const db_file = "res://resouce/database.res"
#var cur_scene = null

func _enter_tree():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
#	cur_scene = get_tree().current_scene
	creat_account()

func creat_account():
	if storager.bind(account) == OK: storager.load_storage()
	else : 
		storager.creat_storage()
		GameDB.new().create_db(db_file)
	account.start()

func goto_scene(path):
	root.add_child(res_loader)
	res_loader.connect("_load_finished",self,"_on_loader_finished")
	res_loader.call_deferred("load_res",path)

func _on_loader_finished(resource):
	var new_scene = resource.instance()
	# Free current scene.
	get_tree().current_scene.free()
	get_tree().current_scene = null
	# Add new one to root.
	get_tree().root.add_child(new_scene)
	# Set as current scene.
	get_tree().current_scene = new_scene
	res_loader.close()

func _exit_tree():
	account.quit_game()
	
