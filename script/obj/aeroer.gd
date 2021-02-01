extends Manager
class_name Aeroer

const cell_scale = Vector2(1,1) # (long,lat)
const cell_size := Vector2(15,15) # pixel
const startpos := Vector2(109,34) # 長安

func _init(form = "aero",type = "aero").(form,type):
	init_data = {"form":form,"ownerid":null,"population":0,"posx":0,"posy":0,"cells":JSON.print({"(0,0)":0})}
	
func _new_member(_data):
	return Aero.new(_data)

func _storedata(id):
	return {"ownerid":members[id].ownerid,"population":members[id].population,"posx":members[id].pos.x,"posy":members[id].pos.y,"cells":JSON.print(members[id].cells)}

func get_aero(pos= null):
	if pos == null : pos = host.account.player.pos 
	var id = aero_id(pos)
	var aero 
	if not id in db_list : aero = create_member(aero_id(pos))
	else :aero = get_member(id)
	return aero

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
