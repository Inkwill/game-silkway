extends Resource
class_name GameTable

var _datapath
var content

func _init(p_file,indexs=[]):
	_datapath = p_file
	content = load_data(p_file,indexs)

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

static func load_data(filepath,indexs,delim: String = ","):
	var file = File.new()
	var err = file.open(filepath,File.READ)
	if err : 
		push_error("File open erro : %s of %s" % [err,filepath])
		return err
	else : 
		var result = {"data":[],"keys":[],"columns":[]}
		result["columns"] = Array(file.get_csv_line(delim))
		for index in indexs:
			if index in result["columns"]:result[index]=[]
			else : index.remove(index)
		while not file.eof_reached():
			var d = Array(file.get_csv_line(delim))
			result["data"].append(d)
			result["keys"].append(d[0])
			for index in indexs:
				result[index].append(d[result["columns"].find(index)])
		file.close()
		return result
