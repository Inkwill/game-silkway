extends Control

export(Vector2) var view_size

var scale_factor := Vector2(1,1)
var tweentime = 2.0
onready var content = $Viewport/bg2in2/content
onready var camera = $Viewport/bg2in2/content/Player/Camera2D
var content_height
var ground_height = 108.0 # under the floor

func _ready():
	var err = get_viewport().connect("size_changed", self, "_on_root_size_changed")
	if err : push_warning("Connect err : _on_root_size_changed")
	content_height = view_size.y  - content.position.y
	zoom(Vector2(0.1,1))
	
func zoom(scale:Vector2):
	scale_factor = Vector2(max(0.1,min(scale.x,1)),max(0.1,min(scale.y,1)))
	$Tween.interpolate_property($ViewTexture,"rect_size",$ViewTexture.rect_size, view_size*scale_factor, tweentime,Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(content,"position:y",content.position.y,view_size.y*scale_factor.y-content_height+ground_height*(1-scale_factor.y+0.1) , tweentime,Tween.TRANS_QUINT, Tween.EASE_OUT)
	if not $Tween.is_active():	$Tween.start()

func _on_ViewTexture_resized():
	$Viewport.size = $ViewTexture.rect_size
	

func _on_root_size_changed():
#	The viewport is resized depending on the window height.
	$ViewTexture.rect_size = get_viewport().size * scale_factor
