extends Object
class_name Figure

var name:String

func _init(_name):
	name = _name
	
func establish(dynasty_name,city_name):
	printerr("%s establish dynasty:%s at %s"%[name,dynasty_name,city_name])
	return 1
	

func test(obj):
	return "Test OK!%s"%obj
