extends Object
class_name Incident

signal progress(_key,_rate)
signal processed(_data)

var data

func _init(id):
	data = host.account.incidenter.value(id)
	process()

func process():
	for i in range(1,11):
		yield(host.tree.create_timer(0.1),"timeout")
		emit_signal("progress",data.id,i,10.0)
	emit_signal("processed",data)
