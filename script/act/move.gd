extends Action
class_name Move

const north = PI/2
const westnorth = PI*3/4
const west = -PI
const westsouth = PI*-3/4 
const south = -PI/2
const eastsouth = -PI/4
const east = 0
const eastnorth = PI/4

var move_path := []  # [step1,step2...step_end]
var dir := {}
var find_road := false
var moved_dis := 0.0
var speed

func _init(_args=null,_type="move").(_args,_type):
	if _args is Array : move_path = _args
	elif _args is Dictionary : dir = _args

func load_data(dic):
	_init_properties(["dir","moved_dis","speed"],dic)
	for pos in dic["move_path"]:
		move_path.append(Mtools.vec2_from_string(pos))
	find_road = dic["find_road"] as bool 
	return .load_data(dic)

func _do_action(_delta):
	_act_move(actor.move_speed *_delta)

func _consume(_duration) -> bool:
	return true

func _is_finished():
	var remain = 0
	if move_path.size() >0: 
		remain = Aeroer.global_distance(actor.pos,move_path[0])
		if abs(remain) <= 0.5 : move_path.remove(0)
	elif dir.size() >0: remain = dir.values()[0] - moved_dis 
	return move_path.size() == 0 and abs(remain) <= 0.5 # km

func _trace_back(_delta):
	._trace_back(_delta)
	var duration = _trace_duration(_delta)
	last_date += duration * 12
	_act_move(speed * duration)
	if  _is_finished(): _finish()
	
func _trace_duration(_duration) -> float:
	return _duration if speed * _duration <= dir.values()[0] else dir.values()[0]/speed
	
func _act_move(dis):
	var next_pos = _get_next_pos(dis)
	actor.pos = next_pos
	moved_dis += dis

func _get_next_pos(dis):
	if move_path.size() > 0:
		var next_pos = move_path[0]
		dis = min(dis,Aeroer.global_distance(actor.pos,move_path[0]))
#		printerr("%s->%s,dir:%s"%[actor.pos,next_pos,actor.pos.direction_to(next_pos)])
		return global_pos_moved(actor.pos,actor.pos.direction_to(next_pos) * dis)
	elif dir.size() > 0:
		dis = min(dis,dir.values()[0] - moved_dis)
		return global_pos_moved(actor.pos,Vector2(dis*cos(get(dir.keys()[0])),dis*sin(get(dir.keys()[0]))))
	else : return actor.pos
	
func _storage_data():
	var data = ._storage_data()
	data["dir"] = dir
	data["move_path"] = move_path
	data["find_road"] = 1 if find_road  else 0
	data["moved_dis"] = moved_dis
	data["speed"] = actor.move_speed
	return data
	
# get (long, lat) of destination
static func global_pos_moved(pos:Vector2,dis:Vector2)-> Vector2:
	var unit = Aeroer.global_unit(pos)
	var x_moved = dis.x/unit.x
	var y_moved = dis.y/unit.y
	return Vector2(pos.x+x_moved, pos.y+y_moved)
#func _get_next_pos():
#	if move_path.size() < 1 :
#		var pos
#		match dir:
#			"north": pos = Vector2(actor.pos.x,actor.pos.y + Aeroer.pos_per_cell().y)
#			"south": pos = Vector2(actor.pos.x,actor.pos.y - Aeroer.pos_per_cell().y)
#			"west": pos = Vector2(actor.pos.x - Aeroer.pos_per_cell().x , actor.pos.y)
#			"east": pos = Vector2(actor.pos.x + Aeroer.pos_per_cell().x , actor.pos.y)
#		move_path.append(pos)
#	return move_path[-1]

#func _moved_pos():
#	match _key:
#		"moveto":return _args
#		"move":
#			var dir = _args.keys()[0] as String
#			var dis = _args.values()[0] as int
#			print("Move dir: %s" % get(dir))
#			return Aeroer.global_pos_moved(start_pos,Vector2(dis*cos(get(dir)*PI),dis*sin(get(dir)*PI)))
#		_:push_error("Send a invalid move (%s,%s)" %[_key,_args])

#func _moved_dis():
#	return Mtools.global_distance(start_pos,end_pos)
