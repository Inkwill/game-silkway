extends Manager
class_name Aeroer

func _init(form = "aero",type = "aero").(form,type):
	pass
	
func _init_data(_id=null):
	return Mtools.combine_dic(._init_data(_id),{"population":Population.new()._init_data(_id),"cells":JSON.print({"0,0":0})})
	
func _new_member(_data):
	return Aero.new(_data)

func _storedata(id):
	return {"ownerid":members[id].ownerid,"population":members[id].population._store_data(),"posx":members[id].pos.x,"posy":members[id].pos.y,"cells":JSON.print(members[id].cells)}

func get_aero(key = null): #null:cur   Vector2:pos   String:id
	if key == null : key = host.account.player.pos
	var id  = aero_id(key) if key is Vector2 else int(key)
#	printerr("get aero:%s,?in:%s"%[id,id in db_list])
	var aero = get_member({"id":id}) if id in db_list else create_member(id)
	return aero
	
static func aero_id(pos:Vector2):
	return int(str(int(pos.y))+str(int(pos.x)))

# get km distance by (longitude,latitude)
static func global_distance(from:Vector2,to:Vector2)-> float: 
	var R = 6378.137 
	return acos(cos(deg2rad(from.y))*cos(deg2rad(to.y))*cos(deg2rad(to.x)-deg2rad(from.x)) + sin(deg2rad(from.y))*sin(deg2rad(to.y)))*R

# distance per one (long, lat)
static func global_unit(pos:Vector2)-> Vector2: 
	var x = global_distance(pos,Vector2(pos.x+1,pos.y))
	var y = global_distance(pos,Vector2(pos.x,pos.y+1))
	return Vector2(x,y)
