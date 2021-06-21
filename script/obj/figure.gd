extends Object
class_name Figure

var name:String

func _init(_name):
	name = _name
	
func establish(dynasty_name,capital_name,date):
	var dynasty = host.account.dynastyer.create_member()
	dynasty.name = dynasty_name
	dynasty.createdate = date
	var capital = host.account.aeroer.get_town({"name":capital_name})
	if capital != null:
		if capital.baser == null : capital.build("capital")
		capital.occupy(dynasty.name)
	return "%s establish dynasty:%s at %s"%[name,dynasty_name,capital_name]
	
func inherit(inheriter):
	return "%s inherit %s" %[self,inheriter]

func test(obj):
	return "test event:%s" % obj
	
func dead():
	return "%s is dead"% self
	
func _to_string():
	return name
	
