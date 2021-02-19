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
	win.tween.connect("tween_step",self,"_on_window_tween")
	win.tween.connect("tween_completed",self,"_on_window_tween_completed")

func _on_window_tween(_caller,_key, _elapsed, _value):
	if _caller.is_open and (_value - ground_size - ui_content.position).y <= 0:
		ui_content.position.y = floor(_value.y - ground_size.y)
	elif not _caller.is_open and (ui_content.position-content_origin).y < 0:
		ui_content.position.y = floor(_value.y - ground_size.y)
		
func _on_window_tween_completed(_caller,_key):
	if not _caller.is_open :GUITools.tween_postion(ui_content,ui_content.position,content_origin)
