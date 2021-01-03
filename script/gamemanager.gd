extends Node

onready var root = get_tree().root
var account = preload("res://resouce/account.tres")
var current_scene = null

func _enter_tree():
	check_storage()

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = get_tree().current_scene
	account.start()

func check_storage():
	var path = "user://%s/"%account.name
	var filename = "account.res"
	if not ResourceLoader.exists(path + filename):
		var dir = Directory.new()
		if dir.open(path) : dir.make_dir(path)
# warning-ignore:return_value_discarded
		ResourceSaver.save(path+filename,account)
	account = ResourceLoader.load(path+filename)
	filename = "world.res"
	if not ResourceLoader.exists(path + filename):
# warning-ignore:return_value_discarded
		ResourceSaver.save(path+filename,account.world)
	account.world = ResourceLoader.load(path+filename)

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
	
