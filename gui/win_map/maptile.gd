extends Control

var _aero
var player
onready var tilemap = $TileMap
onready var ui_player = $Player

func _ready():	
	var dater = host.account.date
	var err = dater.connect("timer_step",self,"_on_timer_step")
	if err : push_warning("GameDate connect err[%s] from maptile.gd" % err)
	
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
	ui_player.position = _actor_pos(player.pos)
#	print("actor position: %s"% player.pos)
#	var old_cell = actormap.get_used_cells_by_id(actormap.tile_set.find_tile_by_name("player"))
#	for old in old_cell:
#		actormap.set_cell(old.x,old.y,-1)
#	var cell_pos_player = _aero.cell_pos(player.pos)
##	print("cell_pos_player%s->%s" %[player.pos,cell_pos_player])
#	actormap.set_cell(cell_pos_player.x,cell_pos_player.y,actormap.tile_set.find_tile_by_name("player"))

func _on_gui_input(event):
	if event.is_pressed():
		var pos = Vector2(event.position.x/tilemap.scale.x,event.position.y/tilemap.scale.y)
		pos = tilemap.world_to_map(pos)
		var cell_id = randi() % 4
		tilemap.set_cell(pos.x,pos.y,cell_id)
		_aero.active_cell(pos,cell_id)

func _actor_pos(pos):
	var world = host.account.world
	var offset = pos-_aero.pos
	var center = rect_size *0.5
#	printerr(Vector2(center.x+ rect_size.x * offset.x * world.world_size.x,center.y - rect_size.y * offset.y * world.world_size.y))
	return Vector2(center.x+ rect_size.x * offset.x * world.world_size.x,center.y - rect_size.y * offset.y * world.world_size.y)

func _on_timer_step(_delta):
	_refresh_map(host.account.world.get_aero())
	_refresh_actor()
