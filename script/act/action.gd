extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"

var actor
var args
var type
var create_date := 0.0
var last_date := 0.0 setget _last_date_setter
var is_active := false

func _init(_actor,_args,_type):
	actor = _actor
	args = _args
	type = _type
	create_date = host.account.curday
	actor.action_list.append(self)
	 
func act():
	if not is_active : return
	print("Action act! %s-%s" % [self,args])
	if last_date > 0 and (host.account.curday-last_date)*12 > host.account.date.timer_interval : _trace_back(12 * (host.account.curday - last_date))
	if is_active : 	host.account.date.add_action(self)

func _trace_back(_delta): # trace back
	print("_trace_back action:%s->%s" % [self,_delta])

func _finish():
	print("Action finish : %s(%s->%s)" % [self,create_date,host.account.curday])
	terminate()

func terminate():
	host.account.date.remove_action(self)
	actor.remove_action(self)
	call_deferred("free")

func _load(_dic):
	create_date = _dic["create_date"]
	last_date = _dic["last_date"]
	is_active = _dic["active"] as bool
	print("load action: %s-%s" %[self,_dic])

func _on_timer_step(_delta):
	set("last_date", host.account.curday)
	
func _on_timer_end(_duration):
	pass

func _storage_data():
	var data = {"type":type,"args":args,"create_date":create_date}
	data["active"] = 1 if is_active else 0
	data["last_date"] = last_date
	return data 

func _last_date_setter(_value):
#	print("last_date %s -> %s" % [last_date, _value])
	last_date = _value
