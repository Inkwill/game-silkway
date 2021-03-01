extends UIWindow
class_name WinMap

onready var map = $Viewport/maptile
onready var view_texture = $ViewTexture


func _on_opened():
	map.connect("select_tile",self,"on_tile_selected")
	$Label.text = "%s, player_tile:%s" % [map._aero,map._player_tile.aero_pos]
	
func _move(dir,dis):
	 Move.new(host.account.player,{dir:dis},true).act()

#func _on_root_size_changed():
#	._on_root_size_changed()
#	$maptile/TileMap.scale = tilemap_scale*window_scale

func _timer_refresh(_delta):
	$Label.text = "%s, player_pos:%s" % [map._aero,host.account.player.pos]
	map.refresh_actor()
	if map._draw_center_aero != host.account.aeroer.get_aero():
		map.refresh_map(host.account.aeroer.get_aero())
	
func on_tile_selected(tile):
	$Label.text = "%s[%s],world_pos:%s" % [tile.aero,tile.aero_pos,tile.world_pos]
	map.tilemark.set_cell(tile.tile_pos.x,tile.tile_pos.y,0)
	if tile.is_actived(): map.show_path(tile)
#	printerr("path :%s"%map.dijkstramap.get_shortest_path_from_point(tile.id))
	
#	for id in tile.around_tile():
#		printerr("%s->%s:%s"%[tile.id,id,map.dijkstramap.has_connection(tile.id,id)])
#	GUITools.message(Aeroer.global_distance(Vector2(0,0),Vector2(0,1)))
	
func _on_bt_close_pressed():
	show_close()

func _on_bt_move_west_pressed():
	_move("west",10)

func _on_bt_zoom_out_pressed():
	map.camera.zoom += Vector2(0.1,0.1)
	
func _on_bt_zoom_in_pressed():
	map.camera.zoom -= Vector2(0.1,0.1)

func _on_bt_move_east_pressed():
	_move("east",10)

func _on_bt_move_north_pressed():
	_move("north",10)

func _on_bt_move_south_pressed():
	_move("south",10)

func _on_bt_focus_player_pressed():
	map.focus_player()

func _on_bt_move_to_pressed():
	var move = null
	for action in host.account.player.action_list:
		if action.type == "move" : move = action
	if move == null and map.path_find != null : move = Move.new(host.account.player,map.path_find,true)
	if move != null : move.act()
