extends Node

onready var tree = get_tree()
onready var root = get_tree().root
var account = preload("res://resouce/storage/account.res")
var storager = preload("res://addons/storage-manager/storager.res").instance()
const db_file = "res://resouce/database.res"

var res_loader

func _enter_tree():
	print("host enter tree")
	creat_account()

func _ready():
	print("host ready")
	GUITools.message(tree.current_scene.name)
	
func creat_account():
	if storager.bind(account) == OK: storager.load_storage()
	else : 
		storager.creat_storage()
		GameDB.new().create_db(db_file)
		account.curday = GameDate.get_juliandate(GameDate.startDate)
	account.start()

func goto_scene(path):
	res_loader = load("res://gui/ui_res_loader/res_loader.tscn").instance()
#	GUITools.tween_color(root,Color(0,0,0,0),Color(0,0,0,1),1)
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
	res_loader.queue_free()
#	GUITools.tween_color(root,Color(0,0,0,1),Color(0,0,0,0),1)

func _exit_tree():
	account.quit_game()
	
