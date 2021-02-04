extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"

var actor
var args
var type
var create_date := 0.0
var last_date := 0.0 setget _last_date_setter
var is_active := false
var duration := 0.0

func _init(_actor,_args,active=false,_type="action"):
	actor = _actor
	args = _args
	type = _type
	is_active = active
	create_date = host.account.curday
	last_date = create_date
	actor.action_list.append(self)
	actor.emit_signal("_s_gameobj_changed",actor,"new_action",self)
	 
func act():
	print("Action act! %s" % self)
	actor.emit_signal("_s_gameobj_changed",actor,"act_action",self)
	if last_date > 0 and (host.account.curday-last_date)*12 > host.account.date.timer_interval : _trace_back(12 * (host.account.curday - last_date))
	if is_active : 	host.account.date.add_action(self)

func _trace_back(_delta): # trace back
	print("_trace_back action:%s->%s" % [self,_delta])

func _is_finished():
#	print("Action is finish ? %s(%s>=%s)" % [ args["timer"]-duration <= 0.01,duration,args["timer"]])
	if "timer" in args : return  args["timer"]-duration <= 0.01
	else: return true

func _finish():
	print("Action finish : %s(%s->%s)" % [self,create_date,last_date])
	_terminate()

func _terminate():
	is_active = false
	host.account.date.remove_action(self)
	actor.remove_action(self)
	call_deferred("free")

func _load(_dic):
	_init_properties(["create_date","last_date","duration"],_dic)
	is_active = _dic["active"] as bool
	print("load action: %s-%s" %[self,_dic])

func _do_action(_delta):
	pass

func _on_timer_step(_delta):
	duration += _delta
	set("last_date", host.account.curday)
	if not _consume(_delta) : 
		print("Action terminated due to unsustainability : %s" % self)
		_terminate()
	_do_action(_delta)
	if  _is_finished(): _finish()

func _consume(_delta):
	return true

func _on_day_step(_duration):
	printerr("day cross:%s"%GameDate.get_time_name(host.account.curday))
	
func _on_moon_step(_duration):
	printerr("moon cross:%s"%GameDate.get_time_name(host.account.curday))
	
func _on_big_hour_step(_duration):
	pass
#	printerr("big hour cross:%s"%GameDate.get_time_name(host.account.curday))

func _storage_data():
	var data = {"type":type,"args":args,"create_date":create_date,"last_date":last_date,"duration":duration}
	data["active"] = 1 if is_active else 0
	return data 

func _last_date_setter(_value):
#	print("last_date %s -> %s" % [last_date, _value])
	last_date = _value

func _to_string() -> String:
	return "%s[%s]"%[type,args]

func _init_properties(names,_dic):
	for name in names:
		if name in _dic : set(name,_dic[name])
