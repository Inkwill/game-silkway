extends Object

class_name Saver 

var savelist := []

func _init():
	pass
	
func add(obj:GameObj):
	savelist.append(obj)

static func save_to_file(data,file_path):
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_line(to_json(data))
	file.close()

static func get_savedata(target):
	if target is GamePlayer:
		return {"name":target.name, "gold":target.gold}

static func savegame() -> bool:
	save_to_file(get_savedata(gameManager.current_player),"user://%s.save"%gameManager.current_player.name)
	return true
