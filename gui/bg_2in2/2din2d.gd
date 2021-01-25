extends Control

export(Vector2) var view_size

var scale_factor := Vector2(1,1)
var tweentime = 1.0
onready var content = $Viewport/bg2in2/content
onready var camera = $Viewport/bg2in2/Camera2D


func _ready():
	var err = get_viewport().connect("size_changed", self, "_on_root_size_changed")
	if err : push_warning("Connect err : _on_root_size_changed")
#	yield(get_tree().create_timer(1.0),"timeout")

func move_content(to):
	$Tween.interpolate_property(content,"position:y",content.position.y,to, tweentime,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if not $Tween.is_active():	$Tween.start()

func zoom(scale:Vector2):
	scale_factor = Vector2(max(0.1,min(scale.x,1)),max(0.1,min(scale.y,1)))
	$Tween.interpolate_property(camera,"zoom",camera.zoom, scale_factor, tweentime,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ViewTexture,"rect_size",$ViewTexture.rect_size, view_size*scale_factor, tweentime,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if not $Tween.is_active():	$Tween.start()

func _on_root_size_changed():
#	The viewport is resized depending on the window height.
	$ViewTexture.rect_size = get_viewport().size * scale_factor
