extends Object
class_name Mtools

static func get_value_list(array,key):
	var data := []
	for d in array:
		data.append(d[key])
	return data

static func d2r(theta):
	return theta * PI/180

static func global_distance(from:Vector2,to:Vector2)-> float: # Vector2(longitude,latitude)
	var R = 6378.137 
	return acos(cos(d2r(from.y))*cos(d2r(to.y))*cos(d2r(to.x)-d2r(from.x)) + sin(d2r(from.y))*sin(d2r(to.y)))*R

static func global_unit(pos:Vector2)-> Vector2: # Vector2(long,lat)
	var x = global_distance(pos,Vector2(pos.x+1,pos.y))
	var y = global_distance(pos,Vector2(pos.x,pos.y+1))
	return Vector2(x,y)

static func global_pos_moved(pos:Vector2,dis:Vector2)-> Vector2:
	var unit = global_unit(pos)
	var x_moved = dis.x/unit.x
	var y_moved = dis.y/unit.y
	return Vector2(pos.x+x_moved, pos.y+y_moved)
