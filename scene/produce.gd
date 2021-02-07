extends Control

var cur_year
var cur_aero

func _ready():
	cur_year = host.begin.year
	cur_aero = 0
	$Label.text = ""
	var _aero = host.account.aeroer.get_aero()
	_refresh()
		
func _refresh():
	$lb_root/lb_aero.text = "Aero: %s/%s"% [cur_aero,host.aero_data.size()]
	$lb_root/lb_history.text = "History: %s/%s" % [cur_year - host.begin.year,host.startDate.year-host.begin.year+1]

func produce_aero():
	var duration := OS.get_unix_time()
	for id in host.aero_data.keys():
		if cur_aero >= host.aero_data.size():break
		$Label.text = "Aero:%s"% host.account.aeroer.get_aero(id)
		yield(host.tree,"idle_frame")
		$lb_root/lb_time.text = "cost time: %s s" % (OS.get_unix_time()-duration)
		cur_aero += 1
		_refresh()

func produce_history():
	var duration := OS.get_unix_time()
	var start_year = cur_year
	for year in range(start_year,host.startDate.year+1):  #GameDate.get_juliandate(host.startDate)):
		var incident = Incident.new(year)
		incident.connect("progress",self,"_on_incident_progress")
		$Label.text = "Year: %s"%yield(incident,"processed")
		$lb_root/lb_time.text = "cost time: %s s" % (OS.get_unix_time()-duration)
		cur_year += 1
		_refresh()
		
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

func _on_incident_progress(event,progress,total):
	$ProgressBar.max_value = total
	$ProgressBar.value = progress
#	print("event completed:%s, progress=%s" % [event,1.0*progress/total])
				
func _on_produce_history():
	produce_history()


func _on_produce_aero():
	produce_aero()
