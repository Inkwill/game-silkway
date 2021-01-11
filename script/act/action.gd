extends Object
class_name Action

var _path = "res://resouce/data/action.res"
var _data 
var _actor = null
var _target = null

func _init(actor,id):
	_actor = actor
	_data = GameTable.new(_path).value(id)
	
func act(target=null):
	_target = target if target != null else _actor
	call(_data.key,_data.value)

func next(value):
	for id in value.split(","):
		print(id)
		
func move(value):
	Move.new("move",Mtools.dic_from_string(value)).at(_target)
		 
