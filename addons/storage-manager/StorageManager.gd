extends Node
class_name StorageManager

var storage_path := "user://"
export(String) var storage_file_path : String = "res://resouce/storage/"

export(String) var password  : String = ""
export(bool)   var blocker   : bool   = true

export(Texture) var error_bg_texture : Texture
export(Color)   var error_alpha_layer_color : Color = Color(0,0,0,.5)
export(Color)   var error_text_color : Color = Color.red
export(String)  var link             : String = "https://"
export(String)  var link_text        : String = "Please, send me a screenshot with this error"

func bind(account):
	storage_path += "%s/"%account.name
	var dir := Directory.new()
	return dir.open(storage_path)

func creat_storage():
	dir_copy(storage_file_path,storage_path)

func load_storage():
	gameManager.account = ResourceLoader.load(storage_path + "account.res")
	gameManager.account.world = ResourceLoader.load(storage_path + "world.res")
	gameManager.db_name = storage_path + "data.db"
	
func load_json(file_name) -> Dictionary:
	var storage = Storage.new(file_name, password)
	var r = storage.load_json()
	if r.result == OK: return r
	if blocker: _show_load_error(r)
	return r

func load_text(file_name) -> Dictionary:
	var storage = Storage.new(file_name, password)
	var r = storage.load_text()
	if r.result == OK: return r
	if blocker: _show_load_error(r)
	return r

func load_data(file_name) -> Dictionary:
	var storage = Storage.new(file_name, password)
	var r = storage.load_data()
	if r.result == OK: return r
	if blocker: _show_load_error(r)
	return r

func store_json(file_name,data : Dictionary) -> Dictionary:
	var storage = Storage.new(file_name, password)
	var r = storage.store_json(data)
	if r.result == OK: return r
	if blocker: _show_store_error(r)
	return r

func store_text(file_name,data : String) -> Dictionary:
	var storage = Storage.new(file_name, password)
	var r = storage.store_text(data)
	if r.result == OK: return r
	if blocker: _show_store_error(r)
	return r

func store_data(file_name,data : Dictionary) -> Dictionary:
	var storage = Storage.new(file_name, password)
	var r = storage.store_data(data)
	if r.result == OK: return r
	if blocker: _show_store_error(r)
	return r

func _show_load_error(json : Dictionary):
	var err = load("res://addons/storage-manager/StorageManagerError.res").instance()
	err.bg_texture = error_bg_texture
	err.alpha_layer_color = error_alpha_layer_color
	err.text_color = error_text_color
	err.text = "An error has occurred loading " + json.file
	err.link = link
	err.link_text = link_text
	err.cause = json.error
	add_child(err)

func _show_store_error(json : Dictionary):
	var err = load("res://addons/storage-manager/StorageManagerError.res").instance()
	err.bg_texture = error_bg_texture
	err.alpha_layer_color = error_alpha_layer_color
	err.text_color = error_text_color
	err.text = "An error has occurred writting " + json.file
	err.link = link
	err.link_text = link_text
	err.cause = json.error
	add_child(err)

static	func dir_contents(path):
	var contents = {"file":[],"dir":[]}
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var cont = dir.get_next()
		while cont != "":
			if dir.current_is_dir():
				contents["dir"].append(cont)
				print("Found directory: " + cont)
			else:
				contents["file"].append(cont)
				print("Found file: " + cont)
			cont = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path:%s" % path)
	return contents

static	func dir_copy(from,to):
	var dir = Directory.new()
	dir.make_dir(to)
	if dir.open(from) == OK:
		dir.list_dir_begin();
		var file_name = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir():
				dir.copy(from + file_name, to + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path:%s."%from)
