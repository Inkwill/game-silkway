extends Node
class_name MapTile

const cell_scale = Vector2(10,10) # cell num per (long,lat)

var _base_aero
var _draw_center_aero
var _pressed
var _selected
var _player_tile
var _aero_list := []
var _path_tiles := {}
var path_find := [] # world_pos
var dijkstramap

var camera_follow := true

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
	
	func _init(map,pos):
		tile_pos = pos
		id = pos_to_id(tile_pos)
		aero_pos = Vector2(precise_pos(tile_pos.x,cell_scale.x),precise_pos(-1*(tile_pos.y+1),cell_scale.y))
		aero = host.account.aeroer.get_aero(map._base_aero.pos + Vector2(precise(tile_pos.x/(cell_scale.x)),precise(-1*(tile_pos.y+1)/(cell_scale.y))))
		world_pos = aero.pos + aero_pos/cell_scale
		center_world_pos = world_pos + Vector2(0.5,0.5)/cell_scale

	static func pos_to_id(tilepos)->int: #saaasbbb,s=1 if negative else 0
		var a = tilepos.x if tilepos.x>=0 else abs(tilepos.x) + 1000
		var b = tilepos.y if tilepos.y>=0 else abs(tilepos.y) + 1000 
		return int(a * 10000 + b)
	
	static func id_to_pos(path_id)->Vector2: 
		var x = path_id /10000
		var y = path_id %10000
		x = -1*(x%1000) if x/1000==1 else x%1000
		y = -1*(y%1000) if y/1000==1 else y%1000  
		return Vector2(x,y)
	
	func around_tile_pos():
		var pos_list = []
		for x in range(tile_pos.x-1,tile_pos.x+2):
			for y in range(tile_pos.y-1,tile_pos.y+2):
				if Vector2(x,y)!= tile_pos:pos_list.append(Vector2(x,y))
		return pos_list
		
	func is_actived():
		return aero.is_actived_cell(aero_pos)
		
	func cell_value():
		return aero.cell_value(aero_pos)
	
	func aero_offset(center):
		return aero.pos - center.pos
	
	func quadrant():
		var x = 1 if aero_pos.x/cell_scale.x >0.5 else -1
		var y = 1 if aero_pos.y/cell_scale.y >0.5 else -1
		return Vector2(x,y) 
	
	func precise(num):
		if num >= 0 : return floor(num)
		else : return -1*ceil(abs(num))
		
	func precise_pos(pos_num,size_num):
		if pos_num >= 0 : return int(pos_num)%int(size_num)
		else:
			var scale = int(abs(pos_num))%int(size_num)
			return scale if scale==0 else size_num - scale

func _ready():
	dijkstramap = DijkstraMap.new()
	_base_aero = host.account.aeroer.get_aero()
	refresh_map(_base_aero)
	refresh_actor()
#	printerr("%s==%s"%[_player_tile.tile_pos,Tile.id_to_pos(_player_tile.id)])
#	var bmp: Rect2 = Rect2(0, 0, 9, 9)
#	var pos_to_id = dijkstramap.add_square_grid(bmp)
#	printerr(pos_to_id.size())
#	for pos in pos_to_id.values():
#		printerr(pos)
	
func refresh_actor():
	var pos = host.account.player.pos
	ui_player.position = _mappos_from_world(pos)
	_player_tile = Tile.new(self,tilemap.world_to_map(_mappos_from_world(pos)))
	for p in tilemark.get_used_cells_by_id(2):
		tilemark.set_cell(p.x,p.y,-1)
	tilemark.set_cell(_player_tile.tile_pos.x,_player_tile.tile_pos.y,2)
	_explore(pos,host.account.player.explore)
	if camera_follow : focus_player()
	
func focus_player():
	GUITools.tween_postion(camera,camera.position,ui_player.position)

func refresh_map(aero,scope=Vector2(1,1)):
	_draw_center_aero = aero
	var offset = aero.pos - _base_aero.pos
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
			_add_pathmap_point(Tile.new(self,Vector2(center.x+i,-1*(center.y+j+1))))
#			if Vector2(center.x+i,-1*(center.y+j+1)) == Vector2(0,0):printerr("aero:%s,center:%s"%[aero,center])
			
func _add_pathmap_point(tile): 
#	if tile.id == 0:printerr("aero:%s,_add_pathmap_point:%s,actived:%s"%[tile.aero,tile.tile_pos,tile.is_actived()])
	if tile.is_actived() :
		_path_tiles[tile.id] = tile
#		printerr("add point:id=%s,cost=%s"%[tile.id,tile.aero.elevation(tile.aero_pos)])
		dijkstramap.add_point(tile.id,1)
		for target_pos in tile.around_tile_pos():
			var target_id = Tile.pos_to_id(target_pos)
			if not dijkstramap.has_connection(tile.id,target_id) and target_id in _path_tiles:
				var err = dijkstramap.connect_points(tile.id,target_id,tile.tile_pos.distance_squared_to(_path_tiles[target_id].tile_pos))
				if err : printerr("connect:%s->%s = %s"%[tile.id,target_id,err])

func _input(event):
	if event is InputEventScreenDrag:
		if _pressed != null : _pressed = null
		camera_follow = false
		camera.position -= event.relative
	elif event is InputEventScreenTouch:
		if event.pressed : _pressed = Tile.new(self,tilemap.world_to_map(_mappos_from_ui(event.position)))
		elif _pressed != null : 
			if _selected != null : tilemark.set_cell(_selected.tile_pos.x,_selected.tile_pos.y,-1)
			_selected = _pressed
			_pressed = null
			emit_signal("select_tile",_selected)
#			printerr(tiles.size())
func show_path(target):
	_show_path(_get_path(_player_tile,target))

func _get_path(from,to)->Array: #[tile_id]
	var start_tile = _get_closest_tile(from,to)
	if start_tile.id == to.id : return [to.id]
	dijkstramap.recalculate(start_tile.id,{"terrain_weights": {1:1.0}})
	var path = dijkstramap.get_shortest_path_from_point(to.id) as Array
	path.invert()
	path.append(to.id)
	return path

func _on_gui_input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag: 
		event.position += (host.root.size - get_parent().size)/2.0
		_input(event)
	
func _explore(pos,explore):
	for tile in _explore_tiles(pos,explore):
		if not tile.is_actived():
			var cell_id = randi() % 4 +1
			tile.aero.active_cell(tile.aero_pos,cell_id)
			tilemap.set_cell(tile.tile_pos.x,tile.tile_pos.y,cell_id)
			_add_pathmap_point(tile)
	
func _explore_tiles(pos,explore): # round(x^0.478/2) f:[0,5]
	var tiles := []
	var size = round(pow(explore,0.478)*0.5)
	var tile_center = tilemap.world_to_map(_mappos_from_world(pos))
	for i in range(-size+1,size):
		for j in range(-size+1,size):
			var tile = Tile.new(self,tile_center + Vector2(i,j))
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
	var map_pos = (pos-_base_aero.pos) * tilemap.cell_size * cell_scale* Vector2(1,-1)
	return map_pos
	
func _mappos_to_world(pos)->Vector2: # to world position (long,lat)
	return _base_aero.pos + (pos/tilemap.cell_size/cell_scale)* Vector2(1,-1)

func _show_path(path):
	path_find.clear()
	for pos in tilemark.get_used_cells_by_id(1):
		tilemark.set_cell(pos.x,pos.y,-1)
	for tile_id in path:
		var tile = _path_tiles[tile_id]
		path_find.append(tile.center_world_pos)
		tilemark.set_cell(tile.tile_pos.x,tile.tile_pos.y,1)
#	printerr(path_find)

func _get_closest_tile(origin,target):
	if origin.id == target.id : return origin
	var result
	var dis_short
	for t in origin.around_tile_pos():
		var tile = Tile.new(self,t)
		var dis = target.world_pos.distance_squared_to(tile.world_pos) *100
		if  dis_short == null or dis -dis_short<0:
#			print("update:dis=%s"%dis)
			dis_short = dis
			result = tile
		if dis_short == 0 : break
#	printerr("result:%s"%[result.id])
	return result

#static func dis_per_cell(pos) -> Vector2:   # km per cell
##	return Vector2(global_unit(pos).x * pos_per_cell().x, global_unit(pos).y * pos_per_cell().y)
#	return Aeroer.global_unit(pos) * Aeroer.cell_scale
