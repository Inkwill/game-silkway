extends Manager
class_name Dynastyer

func _init(type = "dynasty").(type):
	init_data = {"name":"漢","ownerid":null,"posx":0,"posy":0}
	for id in db_list:
		get_member(id)
	host.account.date.connect("timer_step",self,"launch")

func _new_member(_data):
	return Dynasty.new(_data)
	
func _storedata(id):
	return {"name":members[id].name,"ownerid":members[id].ownerid,"posx":members[id].pos.x,"posy":members[id].pos.y}

func launch(duration): #大時
	if members.size() < 1 : create_member()
	for dynasty in members.values():
		printerr("Dynasty:%s operation for %s big hours" %[dynasty.name, duration])
