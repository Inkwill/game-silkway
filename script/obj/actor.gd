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
				"move" : Move.new(self,dic["args"])._load(dic)
				_: Action.new(self,dic["args"])._load(dic)
	else :push_error("Load action by invaild text: %s(%s)" % [actions_data,js.error])

func act():
	for action in action_list:
		if action.is_active : 
			action.act()
			
func remove_action(_action):
	if _action in action_list : action_list.erase(_action)
	else : push_warning("Missing a action when remove:%s of %s"% [_action,self])
	
func gain(sth):
	if sth is Asset:
		if asset == null : 
			asset = sth
			assetid = sth.id
			sth.ownerid = self.id
			self.emit_signal("_s_gameobj_changed",self,"gain",sth)
		else : Effect.new("add",sth.data).at(asset)
	else : push_warning("Gain something that is not Asset:(%s->%s)"% [sth,self])

func _to_string() -> String:
	return "actor_%s[%s]"%[form,name]
	
func _set_name(value:String):
	name = value
	emit_signal("_s_gameobj_changed",self,"set_name",value)
