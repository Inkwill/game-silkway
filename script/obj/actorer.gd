extends Manager
class_name Actorer

func _init(form="actor",type = "actor").(form,type):
	pass

func _init_data():
	return Mtools.combine_dic(._init_data() , {"name":"new_%s"%form,"assetid":-1})

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
