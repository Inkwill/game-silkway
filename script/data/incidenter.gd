extends GameTable
class_name Incidenter

const _path := "res://resouce/data/incident.res"
var incidents := {} #{date->[keys]}
var completed_list := [] #string
var gamedb

signal progress(_key,_progress,_total)
signal processed(_year)

func _init(p_file = _path,indexs=[]).(p_file,indexs):
	gamedb = GameDB.new().gb
	gamedb.query("SELECT incidentid from event WHERE completed == 1;")
	for data in gamedb.query_result:
		completed_list.append(str(data["incidentid"]))
	var keys = Mtools.complement(content.keys,completed_list)
	incidents = Mtools.thread_dic(values(keys,"date"),keys)
	host.account.date.connect("moon_step",self,"_on_moon_step")

func process_year(year):
	var start_date = GameDate.get_juliandate({"year":year,"month":1,"day":1,"hour":12})
	var end_date = GameDate.get_juliandate({"year":year+1,"month":1,"day":1,"hour":12})
	for date in range(start_date,end_date):
		if str(date) in incidents: process_date(date)
	yield(host.tree,"idle_frame")
	emit_signal("processed",year)
	
func process_date(date):
	if str(date) in incidents:
		var events = values(incidents[str(date)])
		for i in range(events.size()):
			var event = Event.new(events[i]).handle()
			yield(host.tree,"idle_frame")
			db_save(events[i])
			emit_signal("progress",event,(i+1.0),events.size())
	

#	for i in range(5-events.size()):
#		events += [{"event":"test","obj":"name:測試⌚️事件","param":"%s"%i}]

func db_save(contents):
	if "id" in contents:
		gamedb.insert_rows("event", [{"incidentid":contents.id,"date":contents.date,"completed":1}])

func _on_moon_step(_duration):
	printerr("Processed ok : %s" % yield(process_date(host.account.curday),"processed"))
