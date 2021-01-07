extends Manager
class_name Asseter

func _init(type = "asset").(type):
	init_data = {"ownerid": null, "coin": 0,"silver":0,"gold":0}
	
func _new_member(_data):
	return Asset.new(_data)

func _storedata(id):
	return {"ownerid":members[id].data["ownerid"], "coin":members[id].data["coin"],"silver":members[id].data["silver"],"gold":members[id].data["gold"]}

func owned_assets(owner_id) ->Array:
	var assets = []
	var datas = gamedb.select_rows(type, "ownerid == %s"%owner_id,GameDB.get_columns(type))
	for data in datas :
		if not data["id"] in members : 
			var asset = Asset.new(data)
			assets.append(asset)
			_register(asset)
		else :	assets.append(members[data["id"]])
	return assets
