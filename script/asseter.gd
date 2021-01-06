extends Object
class_name Asseter

var asset_list := {}
var save_list := []
var db_list := []

func _init():
	var gb = GameDB.get_db(false)
	gb.query("SELECT id from assets;")
	for data in gb.query_result:
		db_list.append(data["id"])
#	gb.close_db()

func _register(asset):
	asset_list[asset.id] = asset
	var err = asset.connect("_s_asset_changed",self,"_on_asset_changed")
	if err : push_warning("%s : %s of %s" % [err,"_s_asset_changed",asset])

func _on_asset_changed(asset,fun,dic):
	if not asset.id in save_list :save_list.append(asset.id)
	print("get signal(asset_changed) %s: %s -> %s) " % [asset,fun,dic])


func new_asset() -> int:
	var gb = GameDB.get_db()
	var data = {"owner": null, "coin": 0,"silver":0,"gold":0}
	gb.insert_rows("assets", [data])
	gb.query("SELECT id from assets ORDER BY id DESC LIMIT 1;")
	data["id"] = gb.query_result[0]["id"]
#	gb.close_db()
	db_list.append(data["id"])
	_register(Asset.new(data))
	return data["id"]

func get_asset(id) -> Asset:
	if id in asset_list.keys() : return asset_list[id]
	if id in db_list:
		var gb = GameDB.get_db()
		var asset = Asset.new(gb.select_rows("assets", "id == %s"%id, ["id","owner","coin","silver","gold"])[0])
		_register(asset)
		return asset
	else:
		push_error("Get asset error: id=%s"%id)
		return id
	
func owned_assets(owner_id) ->Array:
	var assets = []
	var gb = GameDB.get_db()	
	var datas = gb.select_rows("assets", "owner == %s"%owner_id, ["id","owner","coin","silver","gold"])
	for data in datas :
		if not data["id"] in asset_list : 
			var asset = Asset.new(data)
			assets.append(asset)
			_register(asset)
		else :	assets.append(asset_list[data["id"]])
	return assets

func save_assets() :
	if save_list.size() == 0 :return 0
	var num := 0
	var gb = GameDB.get_db()
	for id in save_list:
		if gb.update_rows("assets", "id = %s"%id, {"owner":asset_list[id].data["owner"], "coin":asset_list[id].data["coin"],"silver":asset_list[id].data["silver"],"gold":asset_list[id].data["gold"]}):	
			num +=1
#	gb.close_db()
	return num
