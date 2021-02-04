extends Object
class_name Mtools

static func get_value_list(dic_list,key):
	var data := []
	for dic in dic_list:
		data.append(dic[key])
	return data

static func dic_from_string(text): #k1:v1,k2:v2
	var array = text.split(",")
	var dic := {}
	for a in array :
		dic[a.split(":")[0]]= a.split(":")[1]
	return dic

static func dics_from_string(text): #k1:v1,k2:v2 ; kk1:vv1,kk2:vv2
	var array = text.split(";")
	var result := []
	for a in array :
		result.append(dic_from_string(a))
	return result

static func map_call(obj_list,fuc) -> Array:
	var array := []
	for obj in obj_list :
		array.append(obj.call(fuc))
	return array

static func map(obj,fuc,para_list)->Array:
	var array := []
	for para in para_list:
		array.append(obj.call(fuc,para))
	return array

static func dic_slice(dic:Dictionary,keys:Array)->Dictionary:
	var result := {}
	for key in keys:
		result[key] = dic[key]
	return result

static func complement(array1:Array,array2:Array)->Array:
	var array = array1.duplicate() if array1.size()>array2.size() else array2.duplicate()
	for element in array1:
		if element in array2:array.erase(element)
	return array 

static func thread_dic(array_key:Array,array_value:Array)->Dictionary:
	var dic := {}
	if array_key.size() != array_value.size() : 
		push_error("Thread arrays should have same size!(%s-%s)"%[array_key.size(),array_value.size()])
	else:
		for key in array_key:
			dic[key] = []
		for index in range(array_key.size()):
			dic[array_key[index]].append(array_value[index])
	return dic_slice(dic,delete_duplicate(array_key))


static func thread_call(obj,fuc,args1,args2):
	var result := []
	if args1.size() != args2.size() : 
		push_error("Thread call should have same args size!(%s-%s)"%[args1,args2])
	else:
		for i in range(args1.size()):
			result.append(obj.call(fuc,args1[i],args2[i]))
	return result


static func delete_duplicate(array:Array)->Array:
	var arr = []
	for ele in array:
		if not ele in arr : arr.append(ele)
	return arr

static func combine_dic(dic1:Dictionary,dic2:Dictionary)->Dictionary:
	var result := dic1.duplicate()
	for	key in dic2 :
		if not key in dic1 : result[key] = dic2[key]
		else :
			result[key] = []
			result[key].append(dic1[key]).append(dic2[key])
	return result

static func str_split_between(text,left,right):
	var result :=[]
	result.append(text.rsplit(left)[0])
	result.append(text.rsplit(left)[-1].rsplit(right)[0])
	return result
