extends Node

onready var root = get_tree().root
var account = preload("res://resouce/storage/account.res")
var storager = preload("res://addons/storage-manager/storager.res").instance()
var cur_scene = null

func _enter_tree():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_scene = get_tree().current_scene
	creat_account()

func creat_account():
	if storager.bind(account) == OK: storager.load_storage()
	else : 
		storager.creat_storage()
		GameDB.create_db()
	account.start()

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	cur_scene.free()
	var s = ResourceLoader.load(path)
	cur_scene = s.instance()
	root.add_child(cur_scene)
	get_tree().set_cur_scene(cur_scene)

func _exit_tree():
	account.quit_game()
	
