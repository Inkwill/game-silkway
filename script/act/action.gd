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

func _init(_args=null,_type="action"):
	args = _args
	type = _type
	create_date = host.account.curday
	last_date = create_date

func active(_actor):
	actor = _actor
	is_active = true
	if last_date > 0 and (host.account.curday-last_date)*12 > host.account.date.timer_interval : _trace_back(12 * (host.account.curday - last_date))
	if is_active : 	Mtools.connect_signals(host.account.date,self,["timer_step","day_step","moon_step","big_hour_step"])

func _trace_back(_delta): # trace back
	print("_trace_back action:%s->%s" % [self,_delta])
	actor.emit_signal("_s_gameobj_changed",actor,"act_action","",self)

func _is_finished():
#	print("Action is finish ? %s(%s>=%s)" % [ args["timer"]-duration <= 0.01,duration,args["timer"]])
	if args != null and "timer" in args : return  args["timer"]-duration <= 0.01
	else: return true

func _finish():
	print("Action finished : %s(%s->%s)" % [self,create_date,last_date])
	_terminate()

func _terminate():
	is_active = false
	Mtools.disconnect_signals(host.account.date,self,["timer_step","day_step","moon_step","big_hour_step"])
	actor.remove_action(self)
	call_deferred("free")

func load_data(_dic):
	if args == null : args = _dic
	_init_properties(["create_date","last_date","duration"],_dic)
	is_active = _dic["active"] as bool
#	print("load %s" %self)
	return self

func _do_action(_delta):
	actor.emit_signal("_s_gameobj_changed",actor,"do_action",self,_delta)

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
	return "%s(args:%s)"%[type,args]

func _init_properties(names,_dic):
	for name in names:
		if name in _dic : set(name,_dic[name])
