extends Object
class_name GMtools
var repl

func eval(expr):
	var expr_list = expr.split(" ")
	if has_method(expr_list[0]):return [true,call(expr_list[0],expr_list)]
	else:return [false, "`%s` is not a vaild GM command!"%expr]

func last(_params):
	return repl.last_value
	
func close(_params):
	return repl.close()

func show(params):
	var param_list = params[1].split(".") as Array
	var obj = mainobj(param_list[0])
	for p in param_list.slice(1,-1):
		var fuc = parse_func(p)
		if fuc.size()>0:obj = fuc_call(obj,fuc.keys()[0],fuc.values()[0])
		else:obj = obj.get(p)
	return obj
		
func mainobj(name):
	match name:
		"host":return host
		"account":return host.account
		"aeroer":return host.account.aeroer
		"player":return host.account.player
		_:return self

func parse_func(text)->Dictionary:
	var result = {}
	var predicate = Mtools.str_split_between(text,"(",")")
	if predicate.size() > 1:result[predicate[0]]=predicate[-1]
	return result
	
func fuc_call(obj,fuc,para):
	para = para.split(",") as Array
	para.erase("")
	match para.size():
		0: return obj.call(fuc)
		1: return obj.call(fuc,para[0])
		2: return obj.call(fuc,para[0],para[1])
		3: return obj.call(fuc,para[0],para[1],para[2])
