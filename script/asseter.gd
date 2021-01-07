extends Manager
class_name Asseter

func _init(type = "asset").(type):
	keys =  ["id","ownerid","coin","silver","gold"]
	init_data = {"ownerid": null, "coin": 0,"silver":0,"gold":0}
	
func _new_member(_data):
	return Asset.new(_data)

func owned_assets(owner_id) ->Array:
	var assets = []
	var datas = gamedb.select_rows(type, "ownerid == %s"%owner_id,keys)
	for data in datas :
		if not data["id"] in members : 
			var asset = Asset.new(data)
			assets.append(asset)
			_register(asset)
		else :	assets.append(members[data["id"]])
	return assets

func _save_member() :
	if savers.size() == 0 :return 0
	var num := 0
	for id in savers:
		if gamedb.update_rows(type, "id = %s"%id, {"ownerid":members[id].data["ownerid"], "coin":members[id].data["coin"],"silver":members[id].data["silver"],"gold":members[id].data["gold"]}):	
			num +=1
	return num
