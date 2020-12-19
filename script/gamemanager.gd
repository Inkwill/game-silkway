extends Node

onready var root = get_tree().root
var current_scene = null
var current_player = null
var saver = null
var memberlist := []

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = get_tree().current_scene
	current_player = GamePlayer.new()
	saver = Saver.new()
	add_member(current_player)

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func _exit_tree():
	print("Save gameobj : %s/%s" % saver.savegame())
	
func add_member(obj:GameObj):
	var err = obj.connect("_s_gameobj_changed",saver,"_on_gameobj_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_gameobj_changed",obj])
	else: memberlist.append(obj)
		
