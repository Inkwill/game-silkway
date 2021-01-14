extends Object
class_name Mtools

static func get_value_list(array,key):
	var data := []
	for d in array:
		data.append(d[key])
	return data

static func dic_from_string(text):
	var array = text.split(",")
	var dic = {}
	for a in array :
		dic[a.split(":")[0]]= a.split(":")[1]
	return dic
