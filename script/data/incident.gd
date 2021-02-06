extends Object
class_name Incident

signal progress(_key,_progress,_total)
signal processed(_year)

var year
var events:=[]

func _init(_year):
	year = _year
	init_events()
	process()

func init_events():
	var start_date = GameDate.get_juliandate({"year":year,"month":1,"day":1,"hour":12})
	var end_date = GameDate.get_juliandate({"year":year+1,"month":1,"day":1,"hour":12})
	for date in range(start_date,end_date):
		if str(date) in host.account.incidenter.incidents: events += host.account.incidenter.get_incident(date)
	events += [{"event":"population_increase","obj":"host:aeroer"}]
	for i in range(5-events.size()):
		events += [{"event":"nothing","obj":"name:測試⌚️事件","param":"%s"%i}]
	printerr("%s年:%s"%[year,Mtools.dic_values(events,"event")])
	
func process():
	for i in range(events.size()):
		var event = Event.new(events[i]).handle()
		yield(host.tree,"idle_frame")
		emit_signal("progress",event,(i+1.0),events.size())
	yield(host.tree,"idle_frame")
	emit_signal("processed",year)
