extends JSONRes
class_name Town

var id
var pos
var feature

var createtime

func _init(_id,_ignore=["id","feature","pos"]).(_ignore):
	id = _id
	feature = GameTable.new("res://resouce/data/town.res").value(id)
	pos = Vector2(feature.long,feature.lat)
	
func build():
	var aero = host.account.aeroer.get_aero(pos)
	if not id in aero.towns:
		owner = aero
		owner.towns[id] = self
		createtime = host.account.curday
		for cell_pos in cell_range():
			host.account.aeroer.active_cell(cell_pos,5)
		owner.emit_signal("_s_gameobj_changed",owner,"town",owner.towns,id)
	else : push_warning("Try to rebuild a existed town:%s"%id)
	return self

func cell_range():
	var pos_list = []
	var pos_center = Vector2(stepify(pos.x,0.1),stepify(pos.y,0.1))
	for i in range(-1,2):
		for j in range(-1,2):
			pos_list.append(pos_center+0.1*Vector2(j,i))
	return pos_list

func _to_string():
	return _store_data()
	
