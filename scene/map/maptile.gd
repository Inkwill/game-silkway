extends Node
class_name MapTile

const cell_scale = Vector2(1,1) # (long,lat)
const cell_size := Vector2(15,15) # pixel

var _aero
var _pressed
var _selected
var player

export(Vector2) var map_size
onready var tilemap = $TileMap
onready var tilemark = $TileMap/TileMark
onready var ui_player = $Player
onready var camera = $Camera2D

class Tile:
	var aero
	var aero_pos:Vector2
	var tile_pos:Vector2
	
	func _init(_aero,_pos):
		tile_pos = _pos
		aero_pos = Vector2(precise_pos(_pos.x,cell_size.x),precise_pos(-1*_pos.y,cell_size.y))
		aero = host.account.aeroer.get_aero(_aero.pos + Vector2(precise(_pos.x/(cell_size.x)),precise(-1*_pos.y/(cell_size.y))))
	
	func precise(num):
		if num >= 0 : return floor(num)
		else : return -1*ceil(abs(num))
		
	func precise_pos(pos_num,size_num):
		if pos_num >= 0 : return int(pos_num)%int(size_num)
		else:
			var scale = int(abs(pos_num))%int(size_num)
			return scale if scale==0 else size_num - scale
		
	func active_cell(tilemap,id):
		aero.active_cell(aero_pos,id)
		tilemap.set_cell(tile_pos.x,tile_pos.y,id)
	
func _ready():	
	_refresh_map(host.account.aeroer.get_aero())
	_refresh_actor()

func focus_player():
	GUITools.tween_postion(camera,camera.position,ui_player.position)

func _refresh_map(aero,scope=Vector2(1,0)):
	_aero = aero
	for i in range(-scope.x,scope.x+1):
		for j in range(-scope.y,scope.y+1):
			var draw_aero = host.account.aeroer.get_aero(aero.pos + Vector2(i,j))
			_draw_map(Vector2(i*cell_size.x,j*cell_size.y),draw_aero)
			printerr("draw %s->%s"%[Vector2(i*cell_size.x,j*cell_size.y),draw_aero])

func _draw_map(center,aero):
	for i in range(center.x,center.x + cell_size.x):
		for j in range(center.y,center.y + cell_size.y):
			var aero_pos = Vector2(i% int(cell_size.x),j%int(cell_size.y))
			tilemap.set_cell(i,-j,aero.cell_value(aero_pos))
			if aero_pos == Vector2(0,0):
				printerr("set %s cell[%s] value: %s"%[aero,aero_pos,aero.cell_value(aero_pos)])

func _refresh_actor():
	player = host.account.player
	ui_player.position = _mappos_from_world(player.pos)
	print("player position: %s -> %s"% [player.pos,ui_player.position])

func _input(event):
	if event is InputEventScreenDrag:
		if _pressed != null : _pressed = null
		camera.position -= event.relative
	elif event is InputEventScreenTouch:
		if event.pressed : _pressed = Tile.new(_aero,_tilepos_from_map(event.position))
		elif _pressed != null : 
			_selected = _pressed
			_pressed = null
			printerr("aero:%s,tile_pos:%s, aero_pos:%s" %[_selected.aero,_selected.tile_pos,_selected.aero_pos])
			var cell_id = randi() % 4
			_selected.active_cell(tilemap,cell_id)

func _on_gui_input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag: 
		event.position += (host.root.size - get_parent().size)/2.0
		_input(event)
	
func _tilepos_from_map(pos)->Vector2: #from map position
	var offset = (host.root.size - host.root.size/camera.zoom)/2.0  # zoom导致坐标系偏移
	var camera_offset = camera.position/camera.zoom-offset # camera偏移
	var _pos = (pos+camera_offset)*camera.zoom-host.root.size/2.0 # maptile坐标系偏移
	return tilemap.world_to_map(_pos/tilemap.scale)

func _mappos_from_world(pos)->Vector2: # from world position (lang,lat)
	var map_pos = (pos-_aero.pos) * map_size * Vector2(1,-1)
	return map_pos

static func dis_per_cell(pos) -> Vector2:   # km per cell
#	return Vector2(global_unit(pos).x * pos_per_cell().x, global_unit(pos).y * pos_per_cell().y)
	return Aeroer.global_unit(pos) * pos_per_cell()

static func pos_per_cell() -> Vector2: # (long,lat) per cell 
#	return Vector2(cell_scale.x/cell_size.x, cell_scale.y/cell_size.y)
	return cell_scale/cell_size
