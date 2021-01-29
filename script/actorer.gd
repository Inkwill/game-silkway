extends Manager
class_name Actorer

func _init(type = "actor").(type):
	init_data = {"form":"troop", "name":"new_actor","posx":Aeroer.startpos.x,"posy":Aeroer.startpos.y,"assetid":-1,"ownerid":-1}

func _new_member(_data):
	return Actor.new(_data)

func _storedata(id):
	var data = {"name":members[id].name,"assetid":members[id].assetid,
	"posx":members[id].pos.x,"posy":members[id].pos.y,"ownerid":members[id].ownerid}
	if members[id].action_list.size()>0: 
		data["actions"] = JSON.print(Mtools.map_call(members[id].action_list,"_storage_data"))
		print("Store action %s" % members[id])
	else : data["actions"] = ""
	return data
