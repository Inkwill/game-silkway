extends Object
class_name Figure

var name:String

func _init(_name):
	name = _name
	
func establish(dynasty_name,city_name):
	return "%s establish dynasty:%s at %s"%[name,dynasty_name,city_name]
	
func inherit(inheriter):
	return "%s inherit %s" %[self,inheriter]

func test(obj):
	return "test event:%s" % obj
	
func dead():
	return "%s is dead"% self
	
func _to_string():
	return name
	
