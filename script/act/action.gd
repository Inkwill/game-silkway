extends Object
class_name Action

const _data_path = "res://resouce/data/action.res"
const _ui_path = "res://gui/ui_action/ui_action.tscn"
var _data 
var _actor = null
var _target = null
var ui = null

func _init(actor,id):
	_actor = actor
	_data = GameTable.new(_data_path).value(id)
	ui = load(_ui_path).instance()
	host.root.add_child(ui)
	ui.action = self
	
func act(target=null):
	_target = target if target != null else _actor
	call(_data.key,_data.value)

func next(value):
	ui.next(value)
		
func move(value):
	Move.new("move",Mtools.dic_from_string(value)).at(_target)
		 
