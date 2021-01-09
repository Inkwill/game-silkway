extends Object
class_name Effect

var _key
var _args

func _init(p_key,p_args):
	_key = p_key
	_args = p_args

func _act(t,key,args):
	t.call(key,args)
	
func at(target):
	if target is Array:
		for t in target:
			_act(t,_key,_args)
	elif target is Dictionary:
		for t in target.values():
			_act(t,_key,_args)
	else: _act(target,_key,_args)
