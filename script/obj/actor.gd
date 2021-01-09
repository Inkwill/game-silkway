extends GameObj
class_name Actor

var name:String setget _private_setter
var assetid setget _private_setter
var asset setget _private_setter,_asset_getter
var form:String setget _private_setter

func _init(_data,_type="actor").(_data,_type):
	name = _data["name"]
	assetid = _data["assetid"]
	form = _data["form"]

func _private_setter(_value):
	._private_setter(_value)

func _asset_getter():
	return host.account.asseter.get_member(assetid)

func gain(sth):
	if sth is Asset:
		if asset == null : 
			asset = sth
			assetid = sth.id
			sth.ownerid = id
			emit_signal("_s_gameobj_changed",self,"gain",sth)
		else : Effect.new("add",sth.data).at(asset)
	else : push_warning("Gain something that is not Asset:(%s->%s)"% [sth,self])
