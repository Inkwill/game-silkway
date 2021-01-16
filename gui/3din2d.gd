extends Control

export(Vector2) var view_size

var scale_factor := Vector2(1,1)
var tweentime = 2.0

func _ready():
	var err = get_viewport().connect("size_changed", self, "_on_root_size_changed")
	if err : push_warning("Connect err : _on_root_size_changed")
	
func zoom(scale:Vector2):
	scale_factor = scale
	$Tween.interpolate_property($ViewTexture,"rect_size",$ViewTexture.rect_size, view_size*scale_factor, tweentime,Tween.TRANS_QUINT, Tween.EASE_OUT)
	if not $Tween.is_active():
		$Tween.start()

func _on_ViewTexture_resized():
	$Viewport.size = $ViewTexture.rect_size

func _on_root_size_changed():
#	The viewport is resized depending on the window height.
	$ViewTexture.rect_size = get_viewport().size * scale_factor
