extends Control

var history_dates := [] # date
var processed_dates := [] # date

func _ready():
	history_dates = host.account.incidenter.incidents.keys()
	history_dates.sort()
#	host.account.incidenter.connect("processed",self,"_on_incident_processed")
	refresh_list()

func refresh_list():
	for element in history_dates:
		var lab = Label.new()
		lab.name = element
		lab.text = "date:%s keys:%s"%[element,host.account.incidenter.incidents[element]]
		$list_root.add_child(lab)

func _on_Button_pressed():
	process_history()
#	while inc is GDScriptFunctionState:
#		var incident = inc.resume()

func process_history(): 
	for date in history_dates :
		if int(date) - host.account.curday <= 0:
			var keys = host.account.incidenter.get_incident(date)
			for key in keys:
				var incident = Incident.new(key)
				incident.connect("progress",self,"_on_incident_processed")
				var elem = $list_root.get_node(yield(incident,"processed").date)
				if elem != null : elem.queue_free()
				printerr("Processed ok : %s" % key)
				
func _on_incident_processed(id,rate):
	print("process incident[%s] : %s " % [id,rate])
