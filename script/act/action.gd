extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"

var _data 
var _target = null
var ui = null

func _init(id):
	_data = GameTable.new(_data_path).value(id)
	
func act(target):
	_target = target
	call(_data.key,_data.value)

func next(value):
#	ui.next(value)
	pass
		
func move(value):
	Move.new("move",Mtools.dic_from_string(value)).at(_target)
		 
