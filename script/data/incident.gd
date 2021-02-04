extends Object
class_name Incident

signal progress(_key,_progress,_total)
signal processed(_data)

var date
var events:=[]

func _init(_date):
	date = _date
	init_events()
	process()

func init_events():
	events = host.account.incidenter.get_incident(date)

func process():
	for i in range(events.size()):
		var result = yield(Event.new(events[i]),"completed")
		emit_signal("progress",result,(i+1.0),events.size())
	yield(host.tree,"idle_frame")
	emit_signal("processed",date)


#func get_subject(form,name):
#	match form:
#		"troop":
#			var actor = host.account.trooper.get_member({"name":name})
#			if actor == null:
#				actor = host.account.trooper.create_member()
#				actor.name = name
#			return actor
#		_ : return null
