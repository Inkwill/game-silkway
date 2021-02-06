extends Manager
class_name Aeroer

const _data_path = "res://resouce/data/aero.res"
const cell_scale = Vector2(1,1) # (long,lat)
const cell_size := Vector2(15,15) # pixel
var aero_data

func _init(form = "aero",type = "aero").(form,type):
	aero_data = GameTable.new(_data_path)
	
func _init_data(_id=null):
	return Mtools.combine_dic(._init_data(_id),{"population":Population.new()._init_data(_id),"cells":JSON.print({"(0,0)":0})})
	
func _new_member(_data):
	return Aero.new(_data)

func _storedata(id):
	return {"ownerid":members[id].ownerid,"population":members[id].population._store_data(),"posx":members[id].pos.x,"posy":members[id].pos.y,"cells":JSON.print(members[id].cells)}

func get_aero(key = null): #null:cur   Vector2:pos   String:id
	if key == null : key = host.account.player.pos
	var id  = aero_id(key) if key is Vector2 else int(key)
	printerr("get aero:%s,?in:%s"%[id,id in db_list])
	var aero = get_member({"id":id}) if id in db_list else create_member(id)
	return aero
	
func increase_population():
	return Mtools.map_call(members.values(),"increase_population")

static func aero_id(pos:Vector2):
	return int(str(round(pos.y))+str(round(pos.x)))

# get distance by (longitude,latitude)
static func global_distance(from:Vector2,to:Vector2)-> float: 
	var R = 6378.137 
	return acos(cos(deg2rad(from.y))*cos(deg2rad(to.y))*cos(deg2rad(to.x)-deg2rad(from.x)) + sin(deg2rad(from.y))*sin(deg2rad(to.y)))*R

# distance per one (long, lat)
static func global_unit(pos:Vector2)-> Vector2: 
	var x = global_distance(pos,Vector2(pos.x+1,pos.y))
	var y = global_distance(pos,Vector2(pos.x,pos.y+1))
	return Vector2(x,y)

# get (long, lat) of destination
static func global_pos_moved(pos:Vector2,dis:Vector2)-> Vector2:
	var unit = global_unit(pos)
	var x_moved = dis.x/unit.x
	var y_moved = dis.y/unit.y
	return Vector2(pos.x+x_moved, pos.y+y_moved)

	
static func dis_per_cell(pos) -> Vector2:   # km per cell
#	return Vector2(global_unit(pos).x * pos_per_cell().x, global_unit(pos).y * pos_per_cell().y)
	return global_unit(pos) * pos_per_cell()

static func pos_per_cell() -> Vector2: # (long,lat) per cell 
#	return Vector2(cell_scale.x/cell_size.x, cell_scale.y/cell_size.y)
	return cell_scale/cell_size
