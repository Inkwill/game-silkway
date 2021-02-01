extends Manager
class_name Actorer

var _form

func _init(form="actor",type = "actor").(form,type):
	_form = form
	init_data = {"form":form,
				 "name":"new_%s"%form,
				 "posx":Aeroer.startpos.x,
				 "posy":Aeroer.startpos.y,
				 "createdate":-1,
				 "perishdate":-1,
				 "assetid":-1,
				 "ownerid":-1
				}

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
