extends Object
class_name Effect

var _key
var _args

func _init(p_key,p_args):
	_key = p_key
	_args = p_args

func _occur(t,key,args):
	t.call(key,args)


