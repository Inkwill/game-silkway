#extends Object
#class_name Incident
#
#signal progress(_key,_progress,_total)
#signal processed(_date)
#
#var date
#var events:=[]
#
#func _init(_date):
#	date = _date
#
##func init_events():
##	var start_date = GameDate.get_juliandate({"year":year,"month":1,"day":1,"hour":12})
##	var end_date = GameDate.get_juliandate({"year":year+1,"month":1,"day":1,"hour":12})
##	printerr("start:%s,end:%s"%[start_date,end_date])
##	for date in range(start_date,end_date):
##		if str(date) in host.account.incidenter.incidents: 
##			events += host.account.incidenter.get_incident(date)
##	events += [{"event":"population_increase","obj":"host:aeroer"}]
#
#
#func process():
#	for i in range(events.size()):
#		var event = Event.new(events[i]).handle()
#		yield(host.tree,"idle_frame")
#		host.account.incidenter.db_save(events[i])
#		emit_signal("progress",event,(i+1.0),events.size())
#	yield(host.tree,"idle_frame")
#	emit_signal("processed",date)
