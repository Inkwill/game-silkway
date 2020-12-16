extends Node

onready var root = get_tree().root
var gui_message
var current_scene = null
var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = root.get_child(root.get_child_count() - 1)


func message(message,duration=1):
	gui_message = preload("res://scene/gui/messageBox.tscn").instance()
	current_scene.add_child(gui_message)
	gui_message.show_message(message,duration)

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func savedata():
	var save_dict = {"name":player.name, "gold":player.gold}
	return save_dict
	
func savegame():
	var save_game = File.new()
	save_game.open("user://%s.save"%player.name, File.WRITE)
	save_game.store_line(to_json(savedata()))
	save_game.close()

func _exit_tree():
	savegame()
