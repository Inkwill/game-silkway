extends Control

export(Vector2) var ground_size
var content_origin
var pan_origin

onready var ui_root = $".."
onready var ui_content = $"../bg2/Viewport/bg2in2/content"

func _ready():
	content_origin = ui_content.position
	pan_origin = $pan.rect_position

func show():
	GUITools.tween_postion($pan,pan_origin+Vector2(0,64),pan_origin)

func hide():
	GUITools.tween_postion($pan,pan_origin,pan_origin+Vector2(0,64))

func _on_bt_move_pressed():
	open_window("res://scene/map/winmap.tscn")

func open_window(path):
	hide()
	var win = UIWindow.open_window(ui_root,path)
	win.connect("s_close",self,"show")
	win.connect_tween(self)

func _on_tween_step(_caller,_key, _elapsed, _value):
	if _caller.is_open and (_value - ground_size - ui_content.position).y <= 0:
		ui_content.position.y = floor(_value.y - ground_size.y)
	elif not _caller.is_open and (ui_content.position-content_origin).y < 0:
		ui_content.position.y = floor(_value.y - ground_size.y)
		
func _on_tween_completed(_caller,_key):
	if not _caller.is_open :GUITools.tween_postion(ui_content,ui_content.position,content_origin)


func _on_bt_observe_pressed():
	open_window("res://addons/repl/repl_control.tscn")
