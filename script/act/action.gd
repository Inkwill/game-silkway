extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"

var _data 
var _target = null

func _init(id):
	_data = GameTable.new(_data_path).value(id)
	
func act(options,target=null):
	_target = host.account.player if target == null else target
	call(_data.fuc,options)

func move(options):
	Move.new("move",options[0].value).at(_target)
		 
