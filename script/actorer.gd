extends Manager
class_name Actorer

func _init(type = "actor").(type):
	init_data = {"form":"troop", "name":"new_actor","posx":GameWorld.startpos.x,"posy":GameWorld.startpos.y,"assetid":-1,"ownerid":-1}

func _new_member(_data):
	return Actor.new(_data)

func _storedata(id):
	var data = {"name":members[id].name,"assetid":members[id].assetid,
	"posx":members[id].pos.x,"posy":members[id].pos.y,"ownerid":members[id].ownerid}
	if members[id].action_list.size()>0: data["actions"] = JSON.parse(members[id].action_list[0]._storage_data())
