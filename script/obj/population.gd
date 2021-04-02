extends JSONRes
class_name Population

var mortality:float	#年死亡率
var birth_rate:float	#年出生率

var ethnic_composition:Dictionary	#種族構成 
var aero_composition:Dictionary	#地域構成

var number:int #數量
var satiety:int #飽食度 0~100

var date:int

func _init(_ignore=[]).(_ignore):
	pass

func _init_data(id):
	var data = host.aero_data.value(id)
	mortality = 0.1
	birth_rate = 0.15
	number = int(data["population"]) * 10000
	date = GameDate.get_juliandate(host.begin)
	return _store_data()

func update(): #by year
	var year = (host.account.curday - date)/365.0
	var old_number = number
	number = int(old_number * pow(1 + birth_rate - mortality,year))
	date = host.account.curday
	baser.emit_signal("_s_gameobj_changed",baser,"population",old_number,number)
	
	
func _to_string():
	return "Population:%s"% [number]
	
