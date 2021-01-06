extends Object
class_name Effect

var _fun
var _args

func _init(p_fun,p_args):
	_fun = p_fun
	_args = p_args
	
func _act():
	.call(_fun,_args)

func add_gold(args):
	
