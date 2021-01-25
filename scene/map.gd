extends Control

func _ready():
	$bt_back.connect("pressed",self,"_back_main")
	$bt_move.connect("pressed",self,"_move")
#	$bg2.zoom(Vector2(1.0,0.1))
	
func _back_main():
	host.goto_scene("res://scene/main.tscn")

func _move():
	var move = null
	for action in host.account.player.action_list:
		if action.type == "move" : move = action
	if move == null : move = Move.new(host.account.player,{"north":35},true)
	move.act()
