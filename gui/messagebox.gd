extends Control
class_name MessageBox

onready var tween = $Tween
var show = false

static func message(message,duration=1):
	var gui_message = load("res://gui/messagebox.tscn").instance()
	host.cur_scene.add_child(gui_message)
	gui_message.show_message(message,duration)

func _ready():
	self.rect_position.y = -50

# Called when the node enters the scene tree for the first time.
func show_message(message,duration):
	show = true
	$Panel/Label.text = message
	$Panel.rect_size.y = $Panel/Label.margin_top + $Panel/Label.margin_bottom + (1.5+$Panel/Label.get_line_height())*$Panel/Label.get_line_count()
	tween.interpolate_property($Panel,"rect_position:y",$Panel.rect_position.y, 50, duration,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.interpolate_callback(self,1+duration,"close",duration)
	if not tween.is_active():
			tween.start()

func close(duration):
	show = false
	tween.interpolate_property($Panel,"rect_position:y",$Panel.rect_position.y, -50, 1+duration,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
	if not tween.is_active():
			tween.start()

func _on_tween_all_completed():
	if !show: queue_free()
