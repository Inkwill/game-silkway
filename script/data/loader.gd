extends Object

class_name Loader

static func load_from_file(file_path):
	var file = File.new()
	if file.file_exists(file_path):
		var err = file.open(file_path,File.READ)
		if err : return err
		else : return parse_json(file.get_line())
		file.close()
	return ERR_FILE_NOT_FOUND
