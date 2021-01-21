extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"

var actor
var args
var type

func _init(_actor,_args,_type):
	actor = _actor
	args = _args
	type = _type
	 
func act():
	host.account.date.add_action(self)

func finish():
	print("Action finish : %s" % self)
	host.account.date.finish_action(self)

func _on_timer_step(_delta):
	pass
	
func _on_timer_end(_duration):
	pass

