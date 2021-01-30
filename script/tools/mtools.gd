extends Object
class_name Mtools

static func get_value_list(array,key):
	var data := []
	for d in array:
		data.append(d[key])
	return data

static func dic_from_string(text):
	var array = text.split(",")
	var dic := {}
	for a in array :
		dic[a.split(":")[0]]= a.split(":")[1]
	return dic

static func map_call(obj_list,fuc) -> Array:
	var array := []
	for obj in obj_list :
		array.append(obj.call(fuc))
	return array

static func complement(array1:Array,array2:Array)->Array:
	var array = array1 if array1.size()>array2.size() else array2
	for element in array1:
		if element in array2:array.erase(element)
	return array 

static func thread_dic(array_key:Array,array_value:Array)->Dictionary:
	var dic := {}
	if array_key.size() != array_value.size() : 
		push_error("Thread arrays should have same size!(%s-%s)"%[array_key.size(),array_value.size()])
	else:
		for key in array_key:
			print(key)
			dic[key] = []
		for index in range(array_key.size()):
			dic[array_key[index]].append(array_value[index])
	return dic
