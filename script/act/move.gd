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

var move_path := []  # [end,step_n-1,...step2,step1]
var dir := ""
var find_road := false
var moved_dis := 0.0

func _init(_actor,_args,_type="move").(_actor,_args,_type):
	if _args is Array : move_path = _args
	elif _args is String : dir = _args

func _on_timer_step(_delta):
	var dis = _delta * actor.move_speed
	var pos_step = GameWorld.global_pos_moved(actor.pos,Vector2(dis*cos(get(dir)),dis*sin(get(dir))))
	actor.pos = pos_step
	moved_dis += dis
	print("moved : %s" % moved_dis)
#	dater.run_time(self,GameWorld.global_distance(actor.pos,pos_step)/actor.move_speed)
	if moved_dis >= 30 : finish()

	
func _get_next_pos():
	if move_path.size() < 1 :
		var pos
		match dir:
			"north": pos = Vector2(actor.pos.x,actor.pos.y + GameWorld.pos_per_cell().y)
			"south": pos = Vector2(actor.pos.x,actor.pos.y - GameWorld.pos_per_cell().y)
			"west": pos = Vector2(actor.pos.x - GameWorld.pos_per_cell().x , actor.pos.y)
			"east": pos = Vector2(actor.pos.x + GameWorld.pos_per_cell().x , actor.pos.y)
		move_path.append(pos)
	return move_path[-1]

func _storage_data():
	var data = ._storage_data()
	data["move_path"] = move_path
	data["dir"] = dir
	data["find_road"] = 1 if find_road  else 0
	data["moved_dis"] = moved_dis
	return data

#func _moved_pos():
#	match _key:
#		"moveto":return _args
#		"move":
#			var dir = _args.keys()[0] as String
#			var dis = _args.values()[0] as int
#			print("Move dir: %s" % get(dir))
#			return GameWorld.global_pos_moved(start_pos,Vector2(dis*cos(get(dir)*PI),dis*sin(get(dir)*PI)))
#		_:push_error("Send a invalid move (%s,%s)" %[_key,_args])

#func _moved_dis():
#	return Mtools.global_distance(start_pos,end_pos)
