extends Object
class_name History

func _init(_path):
	print(host.storager.load_json(_path).data[1])
