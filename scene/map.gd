extends Control

func _ready():
	$bt_back.connect("pressed",self,"_back_main")
	$bt_move.connect("pressed",self,"_move")
	$bg2.zoom(Vector2(1.0,0.1))
	
func _back_main():
	host.goto_scene("res://scene/main.tscn")

func _move():
	Move.new("move",{"east":10}).at(host.account.player)
	$maptile._refresh_map(host.account.world.get_aero())
	$maptile._refresh_actor()
