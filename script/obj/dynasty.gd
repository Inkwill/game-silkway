extends Actor
class_name Dynasty 

static func establish(name,morarch):
	var dynasty = host.account.dynastyer.create_member()
	dynasty.name = name
	dynasty.ownerid = morarch.id

func _init(_data).(_data):
	pass
