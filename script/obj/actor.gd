extends GameObj
class_name Actor

var name:String setget _set_name
var assetid 
var asset setget ,_asset_getter
var form:String 
var createdate:int
var perishdate:int

var action_list := []

func _init(_data,_type="actor").(_data,_type):
	_init_properties(["name","assetid"])
	if "actions" in _data : _load_action(_data["actions"])
	
func _asset_getter():
	return host.account.asseter.get_member({"id":assetid})

func _load_action(actions_data):
	if actions_data == "": return
	var js = JSON.parse(actions_data)
	if not js.error :
		for dic in js.result :
			match dic["type"] :
				"move" : add_action(Move.new().load_data(dic))
				_: add_action(Action.new().load_data(dic))
	else :push_error("Load action by invaild text: %s(%s)" % [actions_data,js.error])

func add_action(_action):
	_action.active(self)
	action_list.append(_action)
	emit_signal("_s_gameobj_changed",self,"new_action","",_action)

func remove_action(_action):
	if _action in action_list : action_list.erase(_action)
	else : push_warning("Missing a action when remove:%s of %s"% [_action,self])
	
func perish(date):
	perishdate = int(date)
	emit_signal("_s_gameobj_changed",self,"perish","",date)

func gain(sth):
	if sth is Asset:
		if asset == null : 
			asset = sth
			assetid = sth.id
			sth.ownerid = self.id
			self.emit_signal("_s_gameobj_changed",self,"gain","",sth)
		else : Effect.new("add",sth.data).at(asset)
	else : push_warning("Gain something that is not Asset:(%s->%s)"% [sth,self])

func _to_string() -> String:
	return "actor_%s[%s]"%[form,name]
	
func _set_name(value:String):
	var old_name = name
	name = value
	emit_signal("_s_gameobj_changed",self,"name",old_name,name)
