extends Manager
class_name Aeroer

var town_data

func _init(form = "aero",type = "aero").(form,type):
	town_data = GameTable.new("res://resouce/data/town.res")
	
func _init_data(_id=null):
	var base_data = ._init_data(_id)
	base_data.posx = int(str(_id).right(2))
	base_data.posy = int(str(_id).left(2))
	return Mtools.combine_dic(base_data,{"population":Population.new()._init_data(_id),"cells":JSON.print({"0,0":0}),"towns":JSON.print({})})
	
func _new_member(_data):
	return Aero.new(_data)

func _storedata(id):
	return {"ownerid":members[id].ownerid,"population":members[id].population._store_data(),"posx":members[id].pos.x,"posy":members[id].pos.y,"cells":JSON.print(members[id].cells),"towns":JSON.print(members[id].towns)}

func get_aero(key = null): #null:cur   Vector2:pos   String:id
	if key == null : key = host.account.player.pos
	var id  = aero_id(key) if key is Vector2 else int(key)
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

func get_town(dic): #{key:value}
	var id = dic.id if "id" in dic else null
	if id == null:
		var keys = town_data.get_keys(dic)
		id = keys[0] if keys.size() > 0 else null
	if id != null and id in town_data.keys():
		var town = Town.new(id)
		var aero = get_aero(town.pos)
		return aero.towns[id] if id in aero.towns else town
	else : return null

func active_cell(pos:Vector2,value): # world pos
	var aero = get_aero(pos)
	var cell_pos = (pos - aero.pos)*10
	cell_pos = Vector2(round(cell_pos.x),round(cell_pos.y))
	printerr("active cell:%s->%s"%[aero,cell_pos])
	aero.active_cell(cell_pos,value)
