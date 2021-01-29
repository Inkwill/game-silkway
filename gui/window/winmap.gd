extends UIWindow
class_name WinMap

var tilemap_scale

func _ready():
	tilemap_scale = $maptile/TileMap.scale

func _move(dir,dis):
	var move = null
	for action in host.account.player.action_list:
		if action.type == "move" : move = action
	if move == null : move = Move.new(host.account.player,{dir:dis},true)
	move.act()

#func _on_root_size_changed():
#	._on_root_size_changed()
#	$maptile/TileMap.scale = tilemap_scale*window_scale


func _on_bt_close_pressed():
	show_close()


func _on_bt_move_west_pressed():
	_move("west",100)
