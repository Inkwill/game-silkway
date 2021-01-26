extends UIWindow
class_name WinMap


func _ready():
	pass

func _back_main():
	host.goto_scene("res://scene/main.tscn")

func _move():
	var move = null
	for action in host.account.player.action_list:
		if action.type == "move" : move = action
	if move == null : move = Move.new(host.account.player,{"north":35},true)
	move.act()
