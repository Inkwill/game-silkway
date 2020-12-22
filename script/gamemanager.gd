extends Node

onready var root = get_tree().root
const account = preload("res://resouce/account.tres")
var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	account.start()
	current_scene = get_tree().current_scene

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
	
