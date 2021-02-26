extends GameObj
class_name Aero

var feature
var population
var cells setget _private_setter

func _init(_data,_type="aero").(_data,_type):
	feature = host.aero_data.value(id) if id in host.aero_data.keys() else {"altitude":0,"population":0}
	pos = Vector2(int(str(id).right(2)),int(str(id).left(2)))
	if "population" in _data :population = Population.new(self,_data.population)
	cells = JSON.parse(_data.cells).result

func update():
	var population_update = host.account.curday - population.date
	if population_update < 0 : push_warning("population(%s) date err:date=%s,curday=%s"%[self,population.date,host.account.curday])
	elif population_update >= 1:	population.update()
	return self

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

func cell_id(pos:Vector2)->String:
	return "%s,%s"%[pos.x,pos.y]

func cell_value(pos:Vector2):
	var id = cell_id(pos)
	return cells[id] if id in cells else 0

func is_actived_cell(pos) -> bool:
	if not cell_id(pos) in cells : return false
	else : return cell_value(pos)>0
	
func active_cell(pos,value):
	var id = cell_id(pos)
	if is_actived_cell(pos):push_warning("Illegal operation : repeat active cell![%s,cell:%s] "%[self,id])
	else : 
		cells[id] = value
		emit_signal("_s_gameobj_changed",self,"cell","",{id:value})
		
func elevation(pos):
	var loaded = host.storager.load_json("res://resouce/data/elevation/%s.json"%id)
	if loaded is Dictionary and "data" in loaded:
		if loaded.data is Array and loaded.data.size()>pos.x:
			if loaded.data[pos.x].size()>pos.y: return loaded.data[pos.x][pos.y]
	return feature.altitude
#	var data_file = File.new()
#	var err = data_file.open("res://resouce/%s.txt"%id,File.READ)
#	if err : push_error("elevation data open erro[%s] of %s" % [err,id])
#	else : return 
	
func _private_setter(_value):
	._private_setter(_value)

# get solar declination 日赤緯角 
static func solar_declination(day):
	var b = 2*PI*(day -1)/365 # radian
	return 0.006918 - 0.399912*cos(b) + 0.070257*sin(b) - 0.006758*cos(2*b) + 0.000907*sin(2*b) - 0.002697*cos(3*b) + 0.00148*sin(3*b)

func _to_string():
	return "Aero(%s)"%id

