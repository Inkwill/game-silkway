extends Manager
class_name GameWorld

const begin := {"year":-220,"month":11,"day":14} # 秦始皇帝 二十七年 辛巳年 十月 一日 1641025
const end := {"year":266,"month":2,"day":8} # 西晉武帝 泰始元年 乙酉年 十二月 十七日 1818253
const startDate := {"year":-140,"month":11,"day":01,"hour":12} # 西漢武帝 建元元年 辛丑年 十月 一日 午時 1670231
const startareo = {"ownerid": -1, "posid": 0,"population":0} 
const startpos := Vector2(109,34.5) # 長安

var cur_aero

func _init(type = "aero").(type):
	init_data = {"ownerid":null,"population":0,"posx":0,"posy":0}
	host.account.curday = max(GameDate.get_juliandate(startDate),host.account.curday)
	cur_aero = get_aero(host.account.curplayer.pos)


func _new_member(_data):
	return Aero.new(_data)

func _storedata(id):
	return {"ownerid":members[id].ownerid,"population":members[id].population,"posx":members[id].pos.x,"posy":members[id].pos.y}

func create_aero(pos:Vector2):
	return create_member(aero_id(pos))

func get_aero(pos:Vector2):
	var id = aero_id(pos)
	var aero 
	if not id in db_list : aero = create_aero(pos)
	else :aero = get_member(id)
	return aero

func aero_id(pos:Vector2):
	return int(str(round(pos.y))+str(round(pos.x)))
