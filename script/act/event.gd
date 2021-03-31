extends Object
class_name Event

const pattern_data_path = "res://resouce/data/event.res"
var name :String
var date
#var _keys :Array
var _objtype :Array
var _pattern :Array
var obj :Array
var _obj_param :Array

var param :Array
signal completed(result)

func _init(args): #date obj event param
	var data = GameTable.new(pattern_data_path).value(args.event)
	name = data.name
	date = args.date if "date" in args else host.account.curday
	_objtype = data.objtype.split(";")
	_pattern = data.pattern.split(";")
	
	_obj_param = Mtools.dics_from_string(args.obj)
	obj = Mtools.thread_call(self,"_get_obj",_objtype,_obj_param)
	param = args.param.split(";") if "param" in args else []
	
func handle():
	var result = Mtools.map(self,"_handle",_pattern)
	emit_signal("completed",result)
	return result

func _handle(text):
	var steps = text.split(".")
	var subject =_parse(steps[0])
	var result = subject
	for i in range(1,steps.size()):
		result = _execution(result,steps[i])
	return result

func _execution(subject,text):
	var predicate = Mtools.str_split_between(text,"(",")")
	var fuc = predicate[0]
	var para := []
	if predicate[-1] != "" : 
		for p in predicate[-1].split(","):
			para.append(_parse(p))
	return _pattern_call(subject,fuc,para)
	
func _parse(text):
	if text == "date" : return date
	var _array = Mtools.str_split_between(text,"[","]")
	var value = get(_array[0])
	var index = int(_array[-1])
	if value == null : push_warning("Event(%s) warning: invalid property=%s during parse text :%s!"%[name,_array[0],text])
	elif value.size() > index: value = value[index]
	else : push_warning("Event(%s) warning: invalid index=%s during parse text:%s!"%[name,index,text])
	return value

func _pattern_call(subject,fuc,para):
	if subject == null:
		push_warning("Event[%s] failure: invalid subject[%s]!"%[name,obj])
	elif subject is Object and not subject.has_method(fuc):
		push_warning("Event[%s] failure: invalid function[%s] of obj[%s]!"%[name,fuc,subject])
	else:
#		if fuc == "perish": print("execution: subject=%s, fuc=%s, para=%s"%[subject,fuc,para])
		match para.size():
			0: return subject.call(fuc)
			1: return subject.call(fuc,para[0])
			2: return subject.call(fuc,para[0],para[1])
			3: return subject.call(fuc,para[0],para[1],para[2])

func _get_obj(type,condition):
	var _obj = null
	match type:
		"troop" : _obj= host.account.trooper.get_member(condition)
		"dynasty" : _obj= host.account.dynastyer.get_member(condition)
		"figure" : _obj = Figure.new(condition.name)
		"aeroer" : _obj = host.account.aeroer
	if _obj == null : push_warning("Event<%s> want get a invalid gameobj:%s"%[name,[type,condition]])
	return _obj
