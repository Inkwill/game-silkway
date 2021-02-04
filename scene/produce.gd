extends Control

var cur_date

func _ready():
	cur_date = GameDate.get_juliandate(host.begin)
	$Label.text = str(cur_date)
	
func process_history():
	var duration := OS.get_unix_time()
	for date in range(cur_date,cur_date+10):  #GameDate.get_juliandate(host.startDate)):
		var incident = Incident.new(date)
		incident.connect("progress",self,"_on_incident_processed")
		$Label.text = str(yield(incident,"processed"))
		$Button.text = str(OS.get_unix_time()-duration)

#func refresh_list():
#	for date in range(GameDate.get_juliandate(host.begin),GameDate.get_juliandate(host.startDate)):
#		var keys = host.account.incidenter.get_incident(date)
#		for key in keys:
#			if not key in processed_list and not $list_root.has_node(key): 
#				var lab = Label.new()
#				lab.name = key
#				lab.text = "predicate:%s"%[Mtools.dic_from_string(host.account.incidenter.value(key).predicate).keys()]
#				$list_root.add_child(lab)
#			elif key in processed_list and $list_root.has_node(key):
#				$list_root.get_node(key).queue_free()
#
func _on_Button_pressed():
	process_history()
#
#func process_history(): 
#	for date in history_dates :
#		if int(date) - host.account.curday <= 0:
#			var keys = host.account.incidenter.get_incident(date)
#			for key in keys:
#				var incident = Incident.new(key)
#				incident.connect("progress",self,"_on_incident_processed")
#				processed_list.append(yield(incident,"processed").id)
#				printerr("Processed ok : %s" % key)
#				refresh_list()
				
func _on_incident_processed(_data,progress,total):
#	$Label.text = str(data)
	$ProgressBar.max_value = total
	$ProgressBar.value = progress
	print("result =%s,progress: %s" % [_data,1.0*progress/total])
