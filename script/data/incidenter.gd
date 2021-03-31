extends GameTable
class_name Incidenter

const _path := "res://resouce/data/incident.res"
var incidents := {} #{date->[keys]}
var completed_list := [] #string
var gamedb

func _init(p_file = _path,indexs=[]).(p_file,indexs):
	gamedb = GameDB.new().gb
	gamedb.query("SELECT incidentid from event WHERE completed == 1;")
	for data in gamedb.query_result:
		completed_list.append(str(data["incidentid"]))
	var keys = Mtools.complement(content.keys,completed_list)
	incidents = Mtools.thread_dic(values(keys,"date"),keys)
	host.account.date.connect("moon_step",self,"_on_moon_step")

func db_save(contents):
	if "id" in contents:
		gamedb.insert_rows("event", [{"incidentid":contents.id,"date":contents.date,"completed":1}])

func _on_moon_step(_duration):
	printerr("Processed ok : %s" % yield(Incident.new(host.account.curday),"processed"))

func get_incident(date)->Array: #keys
	date = str(date)
	return values(incidents[date]) if date in incidents else []
