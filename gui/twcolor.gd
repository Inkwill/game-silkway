extends ColorRect
class_name TWColor


static func fade(duration=1.0,reverse=false):
	var tw_color = load("res://gui/twcolor.tscn").instance()
	host.get_tree().current_scene.add_child(tw_color)
	tw_color._play(duration,reverse)

func _play(duration,reverse):
	raise() # Show on top.
	var from = Color(0,0,0,0) if reverse else color
	var to = Color(0,0,0,1) if reverse else Color(0,0,0,0)
	$tw.interpolate_property(self,"color",from,to,duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if not $tw.is_active():$tw.start()	

func _on_tw_tween_all_completed():
	queue_free()
