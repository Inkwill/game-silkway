extends Actorer
class_name Dynastyer

func _init(form = "dynasty").(form):
	for id in db_list:
		get_member({"perishdate":-1})
#	printerr("actorer init:form=%s type=%s members=%s"%[form,type,members])
	host.account.date.connect("timer_step",self,"launch")

func _new_member(_data):
	return Dynasty.new(_data)
	 
func launch(_duration): #大時
	for dynasty in members.values():
		printerr("Dynasty:%s operation for %s big hours" %[dynasty.name, _duration])
