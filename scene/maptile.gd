extends Control

var _aero
var player
onready var tilemap = $TileMap
onready var actormap = $ActorMap

func _ready():	
	_refresh_map(host.account.world.get_aero())
	_refresh_actor()

func _refresh_map(aero):
	if _aero == aero : return
	_aero = aero
	for i in range(_aero.cell_size.x):
		for j in range(_aero.cell_size.y):
			tilemap.set_cell(i,j,_aero.cell_value(Vector2(i,j)))
	
func _refresh_actor():
	player = host.account.player
	var old_cell = actormap.get_used_cells_by_id(actormap.tile_set.find_tile_by_name("player"))
	for old in old_cell:
		actormap.set_cell(old.x,old.y,-1)
	var cell_pos_player = _aero.cell_pos(player.pos)
#	print("cell_pos_player%s->%s" %[player.pos,cell_pos_player])
	actormap.set_cell(cell_pos_player.x,cell_pos_player.y,actormap.tile_set.find_tile_by_name("player"))

func _on_gui_input(event):
	if event.is_pressed():
		var pos = Vector2(event.position.x/tilemap.scale.x,event.position.y/tilemap.scale.y)
		pos = tilemap.world_to_map(pos)
		var cell_id = randi() % 4
		tilemap.set_cell(pos.x,pos.y,cell_id)
		_aero.active_cell(pos,cell_id)
