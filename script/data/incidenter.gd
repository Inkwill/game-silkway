extends GameTable
class_name Incidenter

const _path := "res://resouce/data/incident.res"

func _init(p_file = _path,indexs=["date"]).(p_file,indexs):
	host.account.date.connect("moon_step",self,"check")


func check(_duration=0):
	var check_list = Mtools.complement(content.keys,host.account.incident_list)
	for key in check_list:
		var offset = int(value(key,"date")) - round(host.account.curday)
		if  offset == 0:
			produce(key)
			continue
		elif offset < 0 : continue
		else :
			printerr("incident break in :%s, at date[%s]"% [key,host.account.curday])
			break
			
func pre_produce()->Array:
	var check_list = Mtools.complement(content.keys,host.account.incident_list)
	var dates = values(check_list,"date")
	var dic = Mtools.thread_dic(dates,check_list)
	dates = Mtools.delete_duplicate(dates)
	dates.sort()
	var result := []
	for date in dates :
		var offset = int(date) - round(host.account.curday)
		if offset > 0: return result
		var keys = dic[date]
		result =  result + Mtools.map(self,"produce",keys)
	return result

func produce(key):
	if key in host.account.incident_list : 
		push_error("Want produce a produced incident:%s"%key)
	else:
		host.account.incident_list.append(key)
		return key
