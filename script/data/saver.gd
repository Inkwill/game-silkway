extends Object
class_name GameSaver 

static func save_to_file(data,file_path):
	var file = File.new()
	var err = file.open(file_path, File.WRITE)
	if err : 
		push_error("Save erro : %s of %s" % [err,file_path])
		return false
	else: 
		file.store_line(to_json(data))
		file.close()
		return true

static func saveplayer(players,filepath) -> int:
	var data := {}
	for player in players:
		data[player.name] = player.savedata()
	save_to_file(data,filepath)
	return data.size()
