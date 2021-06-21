extends JSONRes
class_name Town

var id
var name
var pos
enum TYPE {VILLAGE=1,TOWN=2,CITY=3,BIGCITY=4,CAPITAL=5}

var type
var createtime
var dynasty

func _init(_id,_ignore=["id","pos","name"]).(_ignore):
	id = _id
	var data = host.account.aeroer.town_data.value(id)
	pos = Vector2(data.long,data.lat)
	name = data.name

func build(_type):
	_type = type_value(_type)
	baser = host.account.aeroer.get_aero(pos)
	if not id in baser.towns:
		createtime = host.account.curday
		type = _type
		baser.towns[id] = self
		baser.active_cell(baser.pos_from_world(pos),1)
		baser.emit_signal("_s_gameobj_changed",baser,"build",baser.towns,id)
	else : push_warning("Try to rebuild a existed town:%s"%id)
	return self
	
func occupy(owner):
	baser.emit_signal("_s_gameobj_changed",baser,"occupy_town",dynasty,owner)
	dynasty = owner

func type_value(_type):
	match _type:
		"village":return 1
		"town":return 2
		"city":return 3
		"bigcity":return 4
		"capital":return 5
	return _type
#func cell_range():
#	var size = []
#	match type:
#		TYPE.CAPITAL:size = [range(-1,2),range(-1,2)]
#		TYPE.VILLAGE:size = [range(0,1),range(0,1)]
#		TYPE.TOWN:size = [range(0,2),range(0,1)]
#		TYPE.CITY:size = [range(0,2),range(0,2)]
#		TYPE.BIGCITY:size = [range(0,2),range(-1,2)]
#	var pos_list = []
#	var pos_center = Vector2(stepify(pos.x,0.1),stepify(pos.y,0.1))
#	for i in size[0]:
#		for j in size[1]:
#			pos_list.append(pos_center+0.1*Vector2(j,i))
#	return pos_list

func _to_string():
	return _store_data()
	
