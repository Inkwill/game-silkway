extends Control

func _ready():
	$bt_back.connect("pressed",self,"_back_main")
	$bt_move.connect("pressed",self,"_move")
	var dater = host.account.date
	dater.connect("timer_step",self,"_on_timer_step")
#	$bg2.zoom(Vector2(1.0,0.1))
	
func _back_main():
	host.goto_scene("res://scene/main.tscn")

func _move():
	host.account.player.move("north")

func _on_timer_step(_delta):
	$maptile._refresh_map(host.account.world.get_aero())
	$maptile._refresh_actor()
