extends Object
class_name Mtools

static func get_value_list(array,key):
	var data := []
	for d in array:
		data.append(d[key])
	return data

static func dic_from_string(text):
	var array = text.split(",")
	var dic = {}
	for a in array :
		dic[a.split(":")[0]]= a.split(":")[1]
	return dic

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
