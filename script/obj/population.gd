extends JSONRes
class_name Population

var mortality:float	#死亡率
var birth_rate:float	#出生率

var ethnic_composition:Dictionary	#種族構成 
var aero_composition:Dictionary	#地域構成

var number:int #數量
var satiety:int #飽食度 0~100

func _init(_listener=null,_data=null).(_listener,_data):
	pass

func _init_data(id):
	var data = host.aero_data.value(id)
	mortality = 0.1
	birth_rate = 0.15
	number = int(data["population"]) * 10000
	return _store_data()

func increase(): #by year
	number = int(number * (1 + birth_rate - mortality))
	owner.emit_signal("_s_gameobj_changed",owner,"population_increase",self)
	return number
	
func immigrant(_num): #int:number
	pass
	
func _to_string():
	return "Population:%s"% [number]
	
