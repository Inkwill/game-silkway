extends GameTable
class_name Incidenter

const _path := "res://resouce/data/incident.res"
var incidents := {} #{date->[keys]}

func _init(p_file = _path,indexs=["date"]).(p_file,indexs):
	host.account.date.connect("moon_step",self,"_on_moon_step")
	incidents = Mtools.thread_dic(content.date,content.keys)

func _on_moon_step(_duration):
	var keys = get_incident(host.account.curday)
	for key in keys:
		yield(Incident.new(key),"processed")
		printerr("Processed ok : %s" % key)

func get_incident(date)->Array: #keys
	if date in incidents:return incidents[date]
	else:return []
