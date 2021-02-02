extends Control

var history_dates := [] # date
var processed_list := [] # key

func _ready():
	history_dates = host.account.incidenter.incidents.keys()
	history_dates.sort()
	refresh_list()

func refresh_list():
	for date in history_dates:
		var keys = host.account.incidenter.get_incident(date)
		for key in keys:
			if not key in processed_list and not $list_root.has_node(key): 
				var lab = Label.new()
				lab.name = key
				lab.text = "date:%s key:%s"%[date,key]
				$list_root.add_child(lab)
			elif key in processed_list and $list_root.has_node(key):
				$list_root.get_node(key).queue_free()

func _on_Button_pressed():
	process_history()

func process_history(): 
	for date in history_dates :
		if int(date) - host.account.curday <= 0:
			var keys = host.account.incidenter.get_incident(date)
			for key in keys:
				var incident = Incident.new(key)
				incident.connect("progress",self,"_on_incident_processed")
				processed_list.append(yield(incident,"processed").id)
				printerr("Processed ok : %s" % key)
				refresh_list()
				
func _on_incident_processed(id,progress,total):
	$Label.text = host.account.incidenter.value(id).option1
	$ProgressBar.max_value = total
	$ProgressBar.value = progress
#	print("process incident[%s] : %s " % [id,progress/total])
