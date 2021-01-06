extends Object
class_name AssetsManager

var asset_list := {}
var db_list := []

func _init():
	var gb = GameDB.get_db()
	gb.query("SELECT id from assets;")
	for data in gb.query_result:
		db_list.append(data["id"])
	gb.close_db()

func new_asset() -> int:
	var gb = GameDB.get_db()
	var data = {"owner": null, "coin": 0,"silver":0,"gold":0}
	gb.insert_rows("assets", [data])
	gb.query("SELECT id from assets ORDER BY id DESC LIMIT 1;")
	data["id"] = gb.query_result[0]["id"]
	gb.close_db()
	db_list.append(data["id"])
	asset_list[data["id"]] = GameAssets.new(data)
	return data["id"]

func get_asset(id) -> GameAssets:
	print("get_asset:%s in %s or %s" % [id, asset_list, db_list])
	if id in asset_list.keys() : return asset_list[id]
	if id in db_list:
		var gb = GameDB.get_db()
		var asset = GameAssets.new(gb.select_rows("assets", "id == %s"%id, ["id","owner","coin","silver","gold"])[0])
		asset_list[asset.id] = asset
		return asset
	else: return null
	
func owned_assets(owner_id) ->Array:
	var assets = []
	var gb = GameDB.get_db()	
	var datas = gb.select_rows("assets", "owner == %s"%owner_id, ["id","owner","coin","silver","gold"])
	for data in datas :
		if not data["id"] in asset_list : 
			var asset = GameAssets.new(data)
			assets.append(asset)
			asset_list[asset["id"]] = asset
		else :	assets.append(asset_list[data["id"]])
	return assets
			
