extends GameTable
class_name Incidenter

const _path := "res://resouce/data/incident.res"
var incidents := {} #{date->[keys]}

func _init(p_file = _path,indexs=["date"]).(p_file,indexs):
	host.account.date.connect("moon_step",self,"_on_moon_step")
	incidents = Mtools.thread_dic(content.date,content.keys)

func _on_moon_step(_duration):
	printerr("Processed ok : %s" % yield(Incident.new(host.account.curday),"processed"))

func get_incident(date)->Array: #keys
	date = str(date)
	return values(incidents[date]) if date in incidents else []
