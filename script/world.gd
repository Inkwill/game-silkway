extends Manager
class_name GameWorld

const begin := {"year":-220,"month":11,"day":14,"hour":12} # 秦始皇帝 二十七年 辛巳年 十月 一日 1641025
const end := {"year":266,"month":2,"day":8,"hour":12} # 西晉武帝 泰始元年 乙酉年 十二月 十七日 1818253
const startDate := {"year":-140,"month":11,"day":01,"hour":12} # 西漢武帝 建元元年 辛丑年 十月 一日 午時 1670231
const startareo = {"ownerid": -1, "posid": 0,"population":0} 
const startpos := Vector2(109,34) # 長安
const cellnum := 15 # per aero line/cloumn

func _init(type = "aero").(type):
	init_data = {"ownerid":null,"population":0,"posx":0,"posy":0,"cells":JSON.print({"(0,0)":0})}
	print(GameDate.get_juliandate(startDate))
	host.account.curday = max(GameDate.get_juliandate(startDate),host.account.curday)

func _new_member(_data):
	return Aero.new(_data)

func _storedata(id):
	return {"ownerid":members[id].ownerid,"population":members[id].population,"posx":members[id].pos.x,"posy":members[id].pos.y,"cells":JSON.print(members[id].cells)}

func create_aero(pos:Vector2):
	return create_member(aero_id(pos))

func get_aero(pos= null):
	if pos == null : pos = host.account.player.pos 
	var id = aero_id(pos)
	var aero 
	if not id in db_list : aero = create_aero(pos)
	else :aero = get_member(id)
	return aero

static func aero_id(pos:Vector2):
	return int(str(round(pos.y))+str(round(pos.x)))

# get distance by (longitude,latitude)
static func global_distance(from:Vector2,to:Vector2)-> float: 
	var R = 6378.137 
	return acos(cos(deg2rad(from.y))*cos(deg2rad(to.y))*cos(deg2rad(to.x)-deg2rad(from.x)) + sin(deg2rad(from.y))*sin(deg2rad(to.y)))*R

# distance per one (long, lat)
static func global_unit(pos:Vector2)-> Vector2: 
	var x = global_distance(pos,Vector2(pos.x+1,pos.y))
	var y = global_distance(pos,Vector2(pos.x,pos.y+1))
	return Vector2(x,y)

# get (long, lat) of destination
static func global_pos_moved(pos:Vector2,dis:Vector2)-> Vector2:
	var unit = global_unit(pos)
	var x_moved = dis.x/unit.x
	var y_moved = dis.y/unit.y
	return Vector2(pos.x+x_moved, pos.y+y_moved)

# get solar declination 日赤緯角 
static func solar_declination(day):
	var b = 2*PI*(day -1)/365 # radian
	return 0.006918 - 0.399912*cos(b) + 0.070257*sin(b) - 0.006758*cos(2*b) + 0.000907*sin(2*b) - 0.002697*cos(3*b) + 0.00148*sin(3*b)
	
# get sunshine time by (lat,day)
static func sunshine_time(latitude,day):
	return 24/PI * acos(-tan(deg2rad(latitude))*tan(solar_declination(day))) # hours
