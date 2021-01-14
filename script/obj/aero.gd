extends GameObj
class_name Aero

const _data_path = "res://resouce/data/aero.res"
var feature

func _init(_data,_type="aero").(_data,_type):
	feature = GameTable.new(_data_path).value(id)
	pos = Vector2(int(str(id).right(2)),int(str(id).left(2)))
	
func sunshine_time():
	return World.sunshine_time(pos.y,GameDate.day_in_year(host.account.curday))
