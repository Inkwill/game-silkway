extends GameObj
class_name Aero

const _data_path = "res://resouce/data/aero.res"
const cell_size := Vector2(15,15)
const cell_origin := (cell_size - Vector2(1,1))/2.0
var feature
var population
var cells setget _private_setter

func _init(_data,_type="aero").(_data,_type):
	feature = GameTable.new(_data_path).value(id)
	pos = Vector2(int(str(id).right(2)),int(str(id).left(2)))
	population = _data.population
	cells = JSON.parse(_data.cells).result
	
func sunshine_time():
	return World.sunshine_time(pos.y,GameDate.day_in_year(host.account.curday))

func cell_pos(w_pos:Vector2)->Vector2:
	var offset = w_pos - pos
	print(offset)
	return Vector2(cell_origin.x + ceil(offset.x*cell_size.x) - 1, cell_origin.y + ceil(offset.y*cell_size.y) -1)

func cell_value(pos:Vector2):
	return cells[str(pos)] if str(pos) in cells else 0

func active_cell(pos,cell_id):
	pos = str(pos)
	if pos in cells:push_warning("Illegal operation : repeat active_cell![aero:%s,cell:%s] "%[pos,cell_id])
	cells[pos] = cell_id
	emit_signal("_s_gameobj_changed",self,"active_cell",{pos:cell_id})
	
func _private_setter(_value):
	._private_setter(_value)

