extends UIWindow
class_name WinMap

onready var map = $Viewport/maptile
onready var view_texture = $ViewTexture
onready var zoom_slider = $ViewTexture/VSlider
onready var text_win = $Panel/VBoxContainer/HBoxContainer2/textPanel/RichTextLabel
onready var pop_tile = $pop_tile

func _on_opened():
	map.connect("select_tile",self,"on_tile_selected")
	host.account.player.connect("_s_gameobj_changed",self,"on_player_update")
#	$Label.text = "%s, player_tile:%s" % [map._aero,map._player_tile.aero_pos]
	
func _move(dir,dis):
	host.account.player.add_action(Move.new({dir:dis},true))

#func _on_root_size_changed():
#	._on_root_size_changed()
#	$maptile/TileMap.scale = tilemap_scale*window_scale

func on_player_update(_gameobj,_key,_old,_new):
	if _key == "pos":
		map.refresh_actor()
		if map._draw_center_aero != host.account.aeroer.get_aero():
			map.refresh_map(host.account.aeroer.get_aero())
	
func on_tile_selected(tile):
	map.tilemark.set_cell(tile.tile_pos.x,tile.tile_pos.y,0)
	$pop_tile/text.clear()
	$pop_tile/text.add_text("id:%s\n"%tile.id)
	$pop_tile/text.add_text("aero:%s\n"%tile.aero)
	$pop_tile/text.add_text("tile_pos:%s\n"%tile.tile_pos)
	$pop_tile/text.add_text("aero_pos:%s\n"%tile.aero_pos)
	$pop_tile/text.add_text("world_pos:%s\n"%tile.world_pos)
	$pop_tile/text.add_text("obj:%s\n"%tile.obj)
	$pop_tile.popup()
	$pop_tile/bt_move.disabled = !tile.is_actived()
#	printerr("w_pos:%s,aero_pos:%s"%[tile.world_pos,tile.aero.pos_from_world(tile.world_pos)])
#	text_win.add_text("id:%s\n"%tile.id)
#	text_win.add_text("aero:%s\n"%tile.aero) 
#	text_win.add_text("tile_pos:%s\n"%tile.tile_pos)
#	text_win.add_text("aero_pos:%s\n"%tile.aero_pos)
#	text_win.add_text("world_pos:%s\n"%tile.world_pos)
	if tile.is_actived():map.show_path(tile)
#	printerr("path :%s"%map.dijkstramap.get_shortest_path_from_point(tile.id))
	
#	for id in tile.around_tile():
#		printerr("%s->%s:%s"%[tile.id,id,map.dijkstramap.has_connection(tile.id,id)])
#	GUITools.message(Aeroer.global_distance(Vector2(0,0),Vector2(0,1)))
	
func _on_bt_close_pressed():
	close()

func _on_bt_move_west_pressed():
	_move("west",10)

func _on_bt_move_east_pressed():
	_move("east",10)

func _on_bt_move_north_pressed():
	_move("north",10)

func _on_bt_move_south_pressed():
	_move("south",10)

func _on_bt_focus_player_pressed():
	map.focus_player()

func _on_zoom_changed(value):
	var zoom = pow(value,2)/10000 + value/200 + 0.5
	text_win.clear()
	text_win.add_text(str(zoom))
	map.camera.zoom = Vector2(zoom,zoom)

func _on_bt_move_to():
	if not map._selected.is_actived() : return
	var move = null
	for action in host.account.player.action_list:
		if action.type == "move" : move = action
	if move == null and map.path_find != null : host.account.player.add_action(Move.new(map.path_find))

