extends Object
class_name Effect

var _fun
var _args

func _init(p_fun,p_args):
	_fun = p_fun
	_args = p_args
	
func at(target):
	if target is Array:
		for t in target:
			t.call(_fun,_args)
	elif target is Dictionary:
		for t in target.values():
			t.call(_fun,_args)
	else: target.call(_fun,_args)
