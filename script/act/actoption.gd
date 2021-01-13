extends Object
class_name ActOption

const _data_path = "res://resouce/data/actoption.res"
var _data
var value

func _init(id):
	_data = GameTable.new(_data_path).value(id)
	value = {_data.key:_data.value}
