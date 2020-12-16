extends Control

onready var tween = $Tween

func _ready():
	self.rect_position.y = -50

# Called when the node enters the scene tree for the first time.
func show_message(message,duration=1):
	$Panel/Label.text = message
	$Panel.rect_size.y = $Panel/Label.margin_top + $Panel/Label.margin_bottom + (1.5+$Panel/Label.get_line_height())*$Panel/Label.get_line_count()
	tween.interpolate_property($Panel,"rect_position:y",$Panel.rect_position.y, 50, 1,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_callback(self,1+duration,"close")
	if not tween.is_active():
			tween.start()


func close():
	tween.interpolate_property($Panel,"rect_position:y",$Panel.rect_position.y, -50, 1,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
	if not tween.is_active():
			tween.start()
