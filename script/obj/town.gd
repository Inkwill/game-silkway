extends JSONRes
class_name Town

var id
var name
var pos
enum TYPE {VILLAGE,TOWN,CITY,BIGCITY,CAPITAL}

var type #village:1*1  town:1*2   city:2*2   big-city:3*2  capital:3*3
var createtime
var dynasty

func _init(_id,_ignore=["id","pos","name"]).(_ignore):
	id = _id
	var data = host.account.aeroer.town_data.value(id)
	pos = Vector2(data.long,data.lat)
	name = data.name
	
func build(_type):
	type = _type
	var aero = host.account.aeroer.get_aero(pos)
	if not id in aero.towns:
		baser = aero
		baser.towns[id] = self
		createtime = host.account.curday
		for cell_pos in cell_range():
			host.account.aeroer.active_cell(cell_pos,5)
		baser.emit_signal("_s_gameobj_changed",baser,"build",baser.towns,id)
	else : push_warning("Try to rebuild a existed town:%s"%id)
	return self

func cell_range():
	var size = []
	match type:
		TYPE.CAPITAL:size = [range(-1,2),range(-1,2)]
		TYPE.VILLAGE:size = [range(0,1),range(0,1)]
		TYPE.TOWN:size = [range(0,2),range(0,1)]
		TYPE.CITY:size = [range(0,2),range(0,2)]
		TYPE.BIGCITY:size = [range(0,2),range(-1,2)]
	var pos_list = []
	var pos_center = Vector2(stepify(pos.x,0.1),stepify(pos.y,0.1))
	for i in size[0]:
		for j in size[1]:
			pos_list.append(pos_center+0.1*Vector2(j,i))
	return pos_list

func _to_string():
	return _store_data()
	
