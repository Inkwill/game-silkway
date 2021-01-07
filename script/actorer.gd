extends Manager
class_name Actorer

func _init(type = "actor").(type):
	keys =  ["id","form","name","ownerid","assetid"]
	init_data = {"form":"troop", "name":"new_actor","assetid":-1,"ownerid":-1}

func _new_member(_data):
	return Actor.new(_data)

func _save_member() :
	if savers.size() == 0 :return 0
	var num := 0
	for id in savers:
		if gamedb.update_rows(type, "id = %s"%id, {"name":members[id].name,"assetid":members[id].assetid}):	
			num +=1
#	gb.close_db()
	return num
