extends Resource
class_name GameTable

var content

func _init(p_file,indexs=[]):
	content = GameLoader.load_csv(p_file,indexs)
	resource_name = p_file

func _confirm_key(_key):
	return _key

func value(key,column=null):
	if not key in content["keys"] : key = _confirm_key(key)
	var row = content["keys"].find(str(key))
	if row == -1 :
		push_error("Can't find key[%s] in %s" % [key,self])
		return null
	if column == null:
		var element := {}
		for i in content["columns"].size():
			element[content["columns"][i]]=content["data"][row][i]
		return element
	var col = content["columns"].find(str(column))
	if col == -1 :
		push_error("Can't find column[%s] in %s" % [content["columns"],self])
		return null
	return content["data"][row][col]

