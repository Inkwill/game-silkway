extends Manager
class_name Actorer

func _init(type = "actor").(type):
	init_data = {"form":"troop", "name":"new_actor","assetid":-1,"ownerid":-1}

func _new_member(_data):
	return Actor.new(_data)

func _storedata(id):
	return {"name":members[id].name,"assetid":members[id].assetid}
