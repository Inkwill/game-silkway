extends Node

class Tile:
	var pos:Vector2
	
	func _init(_pos):
		pos = _pos

var _aero
var _pressed
var _selected
var player
export(Vector2) var map_size
onready var tilemap = $TileMap
onready var tilemark = $TileMap/TileMark
onready var ui_player = $Player
onready var camera = $Camera2D

func _ready():	
	var dater = host.account.date
	var err = dater.connect("timer_step",self,"_on_timer_step")
	if err : push_warning("GameDate connect err[%s] from maptile.gd" % err)
	
	_refresh_map(host.account.aeroer.get_aero())
	_refresh_actor()

func _refresh_map(aero,scope=Vector2(0,0)):
	if _aero == aero : return
	_aero = aero
	for i in range(-scope.x,scope.x+1):
		for j in range(-scope.y,scope.y+1):
			_draw_map(Vector2(i*host.account.aeroer.cell_size.x,j*host.account.aeroer.cell_size.y),_aero)

func _draw_map(center,aero):
	for i in range(center.x,center.x + host.account.aeroer.cell_size.x):
		for j in range(center.y,center.y + host.account.aeroer.cell_size.y):
			tilemap.set_cell(i,j,aero.cell_value(Vector2(i,j)))

func _refresh_actor():
	player = host.account.player
	ui_player.position = _pos_to_map(player.pos)
	print("player position: %s -> %s"% [player.pos,ui_player.position])
#	var old_cell = actormap.get_used_cells_by_id(actormap.tile_set.find_tile_by_name("player"))
#	for old in old_cell:
#		actormap.set_cell(old.x,old.y,-1)
#	var cell_pos_player = _aero.cell_pos(player.pos)
##	print("cell_pos_player%s->%s" %[player.pos,cell_pos_player])
#	actormap.set_cell(cell_pos_player.x,cell_pos_player.y,actormap.tile_set.find_tile_by_name("player"))

func _input(event):
	if event is InputEventScreenDrag:
		if _pressed != null : _pressed = null
		camera.position -= event.relative
	elif event is InputEventScreenTouch:
		if event.pressed : _pressed = Tile.new(tilemap.world_to_map(_pos_from_gui(event.position)/tilemap.scale))
		elif _pressed != null : 
			_selected = _pressed
			_pressed = null
			print("gui postion:%s"%(event.position))
			printerr(str(_selected.pos))
#			var pos = Vector2(event.position.x/tilemap.scale.x,event.position.y/tilemap.scale.y)
#			pos = tilemap.world_to_map(pos)
#			var cell_id = randi() % 4
#			tilemap.set_cell(pos.x,pos.y,cell_id)
#			_aero.active_cell(pos,cell_id)

func _on_gui_input(event):
	if event is InputEventScreenTouch and not event.pressed: 
		print("gui postion:%s"%event.position)
		event.position += Vector2(0,120)
		print("gui postion:%s"%event.position)
	_input(event)
	
func _pos_from_gui(pos):
#	var quadrant = pos - map_size/2.0
	var offset = (map_size - map_size/camera.zoom)/2.0
	var camera_offset = camera.position/camera.zoom-offset
#	if quadrant == Vector2(0,0) : return pos
#	elif quadrant.x >= 0 and quadrant.y <= 0: return pos+offset*Vector2(1,-1)
#	elif quadrant.x >= 0 and quadrant.y >= 0: return pos+offset*Vector2(1,1)
#	elif quadrant.x <= 0 and quadrant.y >= 0: return pos+offset*Vector2(-1,1)
#	elif quadrant.x <= 0 and quadrant.y <= 0: return pos+offset*Vector2(-1,-1)
	return (pos+camera_offset)*camera.zoom

	
func _pos_to_map(pos):
	var aeroer = host.account.aeroer
	var offset = pos-_aero.pos
	var center = map_size *0.5
#	return  center + Vector2(map_size.x * offset.x * aeroer.cell_scale.x, -1* map_size.y * offset.y * aeroer.cell_scale.y)
	return center + map_size * offset * aeroer.cell_scale * Vector2(1,-1)
	
func _on_timer_step(_delta):
	_refresh_map(host.account.aeroer.get_aero())
	_refresh_actor()

