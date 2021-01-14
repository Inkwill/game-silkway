extends Effect
class_name Move

const north = 1/2.0
const westnorth = 3/4.0
const west = -1
const westsouth = -3/4.0 
const south = -1/2.0 
const eastsouth = -1/4.0 
const east = 0
const eastnorth =1/4.0

var start_pos
var end_pos
var move_dis

func _init(p_key,p_args).(p_key,p_args):
	pass

func _act(t,_key,_args):
	start_pos = t.pos
	end_pos = _moved_pos()
	t.set("pos",end_pos)

func _moved_pos():
	match _key:
		"moveto":return _args
		"move":
			var dir = _args.keys()[0] as String
			var dis = _args.values()[0] as int
			print("Move dir: %s" % get(dir))
			return GameWorld.global_pos_moved(start_pos,Vector2(dis*cos(get(dir)*PI),dis*sin(get(dir)*PI)))
		_:push_error("Send a invalid move (%s,%s)" %[_key,_args])

func _moved_dis():
	return Mtools.global_distance(start_pos,end_pos)
