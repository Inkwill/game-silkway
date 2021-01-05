extends Node

onready var root = get_tree().root
var account = preload("res://resouce/storage/account.res")
var storager = preload("res://addons/storage-manager/storagemanager.res").instance()
var current_scene = null

func _enter_tree():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = get_tree().current_scene
	creat_account()

func creat_account():
	if storager.bind(account) == OK: storager.load_storage()
	else : 
		storager.creat_storage()
		GameDB.create_db(account.name)
	account.start()

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func _exit_tree():
	account.quit_game()
	
