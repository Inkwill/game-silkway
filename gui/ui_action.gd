extends Control
class_name UIAction

var _id
var _actor
var action

static func create(root,actor,id):
	var ui_action = load("res://gui/action.tscn").instance()
	ui_action._id = id
	ui_action._actor = actor
	root.add_child(ui_action)

func _ready():
	print("%s,%s"%[_actor,_id])
	action = Action.new(_actor,_id)

func _on_bt_base_pressed():
	action.act()
	queue_free()
