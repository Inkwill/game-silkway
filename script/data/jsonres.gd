extends Object
class_name JSONRes

var property_list
var owner

func _init(_ignore=[]):
	property_list = Mtools.dic_values(get_property_list(),"name")
	property_list = Mtools.erase_list(property_list,["owner","listener","property_list","Script","script","Script Variables"])
	if _ignore.size()>0 :property_list = Mtools.erase_list(property_list,_ignore)

func _parse_data(_data):
	var js = JSON.parse(_data)
	if not js.error :
		for key in js.result :
			if key in property_list:
				set(key,js.result[key])
#				printerr("_parse_data key:%s->%s"%[key,js.result[key]])
	else :push_error("Load JSONRes by invaild text: %s(%s)" % [_data,js.error])
	return self

func _store_data():
	var data = {}
	for property in property_list:
		data[property] = get(property)
	return JSON.print(data)
