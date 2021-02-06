extends GameObj
class_name Aero

var aeroer = host.account.aeroer
var cell_size = aeroer.cell_size
var cell_origin = (cell_size - Vector2(1,1))/2.0

var feature
var population
var cells setget _private_setter

func _init(_data,_type="aero").(_data,_type):
	feature = aeroer.aero_data.value(id)
	pos = Vector2(int(str(id).right(2)),int(str(id).left(2)))
	if "population" in _data :population = Population.new(self,_data.population)
	cells = JSON.parse(_data.cells).result

func increase_population():
	return population.increase()

func sunshine_time(): # quarter
	var day = GameDate.day_in_year(host.account.curday)
	var hour = 24/PI * acos(-tan(deg2rad(pos.y))*tan(solar_declination(day))) # hours
	return 4*hour 
	
func sunshine_cycle():
	var cycle := {}
	var sqter = sunshine_time()
	cycle["day"] = sqter/4.0
	cycle["dusk_s"] = sqter*3/8.0
	cycle["dusk_e"] = sqter/2.0
	cycle["dawn_s"] = 96-sqter/2.0
	cycle["dawn_e"] = 96-sqter*3/8.0
	return cycle

func sunrise():  # quarter
	return 96 - sunshine_time()/2
	
func sunset():
	return sunshine_time()/2

func cell_pos(w_pos:Vector2)->Vector2:
	var offset = w_pos - pos
	return Vector2(cell_origin.x + ceil(offset.x*(cell_size.x-1)), cell_origin.y - ceil(offset.y*(cell_size.y-1)))

func cell_value(pos:Vector2):
	return cells[str(pos)] if str(pos) in cells else 0

func active_cell(pos,cell_id):
	pos = str(pos)
	if pos in cells:push_warning("Illegal operation : repeat active_cell![aero:%s,cell:%s] "%[pos,cell_id])
	cells[pos] = cell_id
	emit_signal("_s_gameobj_changed",self,"active_cell",{pos:cell_id})
	
func _private_setter(_value):
	._private_setter(_value)

# get solar declination 日赤緯角 
static func solar_declination(day):
	var b = 2*PI*(day -1)/365 # radian
	return 0.006918 - 0.399912*cos(b) + 0.070257*sin(b) - 0.006758*cos(2*b) + 0.000907*sin(2*b) - 0.002697*cos(3*b) + 0.00148*sin(3*b)

func _to_string():
	return "Aero(%s)"%id

