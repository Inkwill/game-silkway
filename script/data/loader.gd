extends Object
class_name GameLoader

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

static func load_from_file(file_path):
	var file = File.new()
	var err = file.open(file_path,File.READ)
	if err : 
		push_error("Load erro : %s of %s" % [err,file_path])
		return err
	else : 
		var data = parse_json(file.get_line())
		file.close()
		return data

static func load_player(player,filepath):
	var data = load_from_file(filepath)
	if data is Dictionary: 
		if player.name in data : player.loaddata(data[player.name])
		else: push_error("No player_data of %s from %s " % [player,filepath])
	else : push_error("Load data erro : %s to %s from %s" % [data,player,filepath])
