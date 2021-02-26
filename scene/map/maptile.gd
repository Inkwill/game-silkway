extends Node
class_name MapTile

const cell_scale = Vector2(10,10) # cell num per (long,lat)

var _aero
var _draw_center_aero
var _pressed
var _selected
var _player_tile
var _aero_list := []
var _tiles := {}

export(Vector2) var map_size
onready var tilemap = $TileMap
onready var tilemark = $TileMap/TileMark
onready var ui_player = $Player
onready var camera = $Camera2D

signal select_tile(tile)

class Tile:
	var id:int
	var aero
	var aero_pos:Vector2
	var tile_pos:Vector2
	var world_pos:Vector2
	var center_world_pos:Vector2
	
	func _init(_aero,_tilepos):
		tile_pos = _tilepos
		aero_pos = Vector2(precise_pos(tile_pos.x,cell_scale.x),precise_pos(-1*(tile_pos.y+1),cell_scale.y))
		aero = host.account.aeroer.get_aero(_aero.pos + Vector2(precise(tile_pos.x/(cell_scale.x)),precise(-1*(tile_pos.y+1)/(cell_scale.y))))
		world_pos = aero.pos + aero_pos/cell_scale 
		center_world_pos = world_pos + Vector2(0.5,0.5)/cell_scale

	func is_actived():
		return aero.is_actived_cell(aero_pos)
		
	func cell_value():
		return aero.cell_value(aero_pos)
	
	func aero_offset(base_aero):
		return aero.pos - base_aero.pos
	
	func quadrant():
		var x = 1 if aero_pos.x/cell_scale.x >0.5 else -1
		var y = 1 if aero_pos.y/cell_scale.y >0.5 else -1
		return Vector2(x,y) 
	
	func active(tilemap):
		if not is_actived():
			var cell_id = randi() % 4 +1
			aero.active_cell(aero_pos,cell_id)
			tilemap.set_cell(tile_pos.x,tile_pos.y,cell_id)
	
	func precise(num):
		if num >= 0 : return floor(num)
		else : return -1*ceil(abs(num))
		
	func precise_pos(pos_num,size_num):
		if pos_num >= 0 : return int(pos_num)%int(size_num)
		else:
			var scale = int(abs(pos_num))%int(size_num)
			return scale if scale==0 else size_num - scale

func _ready():
	_aero = host.account.aeroer.get_aero()
	refresh_map(_aero)
	refresh_actor()
	
#	var dijkstramap = DijkstraMap.new()
#	var bmp: Rect2 = Rect2(0, 0, 9, 9)
#	var pos_to_id = dijkstramap.add_square_grid(bmp)
#	printerr(pos_to_id.size())
#	for pos in pos_to_id.values():
#		printerr(pos)
	
func refresh_actor():
	var pos = host.account.player.pos
	ui_player.position = _mappos_from_world(pos)
	_player_tile = Tile.new(_aero,tilemap.world_to_map(_mappos_from_world(pos)))
	Mtools.map_call(around_tiles(pos,host.account.player.explore),"active",tilemap)
	focus_player()
	
func focus_player():
	GUITools.tween_postion(camera,camera.position,ui_player.position)

func refresh_map(aero,scope=Vector2(0,0)):
	_draw_center_aero = aero
	var offset = aero.pos - _aero.pos
#	printerr("refresh map :%s"%[aero])
	for i in range(-scope.x,scope.x+1):
		for j in range(-scope.y,scope.y+1):
			var aero_draw = host.account.aeroer.get_aero(_draw_center_aero.pos + Vector2(i,j))
			if not aero_draw in _aero_list:
				_draw(Vector2((i+offset.x)*cell_scale.x,(j+offset.y)*cell_scale.y),aero_draw)
				_aero_list.append(aero_draw)

func _draw(center,aero):
#	printerr("_draw map :%s"%[center])
	for i in cell_scale.x:
		for j in cell_scale.y:
			tilemap.set_cell(center.x+i,-1*(center.y+j+1),aero.cell_value(Vector2(i,j)))
			var tile = Tile.new(_aero,Vector2(center.x+i,-1*(center.y+j+1)))
			tile.id = _tiles.size()+1
			_tiles[tile.id] = tile
	
func _input(event):
	if event is InputEventScreenDrag:
		if _pressed != null : _pressed = null
		camera.position -= event.relative
	elif event is InputEventScreenTouch:
		if event.pressed : _pressed = Tile.new(_aero,tilemap.world_to_map(_mappos_from_ui(event.position)))
		elif _pressed != null : 
			if _selected != null : tilemark.set_cell(_selected.tile_pos.x,_selected.tile_pos.y,-1)
			_selected = _pressed
			_pressed = null
			tilemark.set_cell(_selected.tile_pos.x,_selected.tile_pos.y,0)
			emit_signal("select_tile",_selected)
#			printerr(tiles.size())

func _on_gui_input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag: 
		event.position += (host.root.size - get_parent().size)/2.0
		_input(event)
	
func around_tiles(pos,explore): # round(x^0.478/2) f:[0,5]
	var tiles := []
	var size = round(pow(explore,0.478)*0.5)
	var tile_center = tilemap.world_to_map(_mappos_from_world(pos))
	for i in range(-size+1,size):
		for j in range(-size+1,size):
			var tile = Tile.new(_aero,tile_center + Vector2(i,j))
			var offset = (tile.center_world_pos-pos).length_squared()*cell_scale.x*cell_scale.y
			if size*0.5-offset >= 0 :
				tiles.append(tile)
	return tiles	

func _mappos_from_ui(pos)->Vector2: # from ui pos
	var offset = (host.root.size - host.root.size/camera.zoom)/2.0  # zoom导致坐标系偏移
	var camera_offset = camera.position/camera.zoom-offset # camera偏移
	var _pos = (pos+camera_offset)*camera.zoom-host.root.size/2.0 # maptile坐标系偏移
	return _pos

func _mappos_from_world(pos)->Vector2: # from world position (long,lat)
	var map_pos = (pos-_aero.pos) * tilemap.cell_size * cell_scale* Vector2(1,-1)
	return map_pos
	
func _mappos_to_world(pos)->Vector2: # to world position (long,lat)
	return _aero.pos + (pos/tilemap.cell_size/cell_scale)* Vector2(1,-1)

#static func dis_per_cell(pos) -> Vector2:   # km per cell
##	return Vector2(global_unit(pos).x * pos_per_cell().x, global_unit(pos).y * pos_per_cell().y)
#	return Aeroer.global_unit(pos) * Aeroer.cell_scale
