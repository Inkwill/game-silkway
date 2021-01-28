extends Control

export(Vector2) var view_size

#var scale_factor := Vector2(1,1)
var content_origin
var window_scale
onready var content = $Viewport/bg2in2/content
onready var camera = $Viewport/bg2in2/Camera2D


func _ready():
	var err = get_viewport().connect("size_changed", self, "_on_root_size_changed")
	if err : push_warning("Connect err : _on_root_size_changed")
	content_origin = content.position
	window_scale = get_viewport().size/view_size

func move_content(to,tweentime=1.0):
	$Tween.interpolate_property(content,"position:y",content.position.y,to, tweentime,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if not $Tween.is_active():	$Tween.start()

#func zoom(scale:Vector2,tweentime=1.0):
#	scale_factor = Vector2(max(0.1,min(scale.x,1)),max(0.1,min(scale.y,1)))
#	$Tween.interpolate_property(camera,"zoom",camera.zoom, scale_factor, tweentime,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($ViewTexture,"rect_size",$ViewTexture.rect_size, view_size*scale_factor, tweentime,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	if not $Tween.is_active():	$Tween.start()

func _on_root_size_changed():
#	The viewport is resized depending on the window height.
#	$ViewTexture.rect_size = get_viewport().size * scale_factor
	window_scale = get_viewport().size/view_size

