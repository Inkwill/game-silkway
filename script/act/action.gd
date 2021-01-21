extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"

var actor
var args
var type
var is_active :=false

func _init(_actor,_args,_type):
	actor = _actor
	args = _args
	type = _type
	actor.action_list.append(self)
	 
func act():
	is_active = true
	host.account.date.add_action(self)

func finish():
	print("Action finish : %s" % self)
	host.account.date.finish_action(self)
	actor.finish_action(self)
	call_deferred("free")
#	queue_free()

func _on_timer_step(_delta):
	pass
	
func _on_timer_end(_duration):
	pass

func _storage_data():
	pass
