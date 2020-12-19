extends Object

class_name Saver 

var savelist := []

func _init():
	pass
	

static func save_to_file(data,file_path):
	var file = File.new()
	var err = file.open(file_path, File.WRITE)
	if err : return err
	file.store_line(to_json(data))
	file.close()
	return OK

func savegame() -> Array:
	var result = [savelist.size()]
	var savednum = 0
	for obj in savelist:
		var err = obj.save()
		if err : push_error("Save err : %s of %s" % [err,obj])
		else : savednum += 1
	result.append(savednum)
	return result

func _on_gameobj_changed(obj,property,old,new):
	print("get signal(gameobj_changed) %s: %s -> %s " % [property,old,new])
	if not obj in savelist : savelist.append(obj)
