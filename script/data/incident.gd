extends GameTable
class_name Incident

const _path := "res://resouce/data/incident.res"
var _remain_list := []

func _init(p_file = _path,indexs=["date"]).(p_file,indexs):
	host.account.date.connect("moon_step",self,"check")
	_remain_list = Mtools.complement(content.keys,host.account.incident_list)   # need complement

func check(_duration=0):
	var cur_date = host.account.curday
	for key in _remain_list:
		var offset = int(value(key,"date")) - round(cur_date)
		if  offset == 0:
			produce(key)
			continue
		elif offset < 0 : continue
		else :
			printerr("incident break in :%s, at date[%s]"% [value(key),host.account.curday])
			break
			
func pre_produce():
	var dates = values(_remain_list,"date")
	var dic = Mtools.thread_dic(dates,_remain_list)
	dates = Mtools.delete_duplicate(dates)
	dates.sort()
	for date in dates :
		var keys = dic[date] 
		printerr("produce incident : %s" % [keys])
		Mtools.map(self,"produce",keys)
#		print(content["keys"].size())
#		print("date:%s,index:%s"%[date,content["date"].find(date)])
#		var keys = content.keys[dic[date]]
#		Mtools.map(self,"produce",keys)
#		if not key in host.account.incident_list : produce(key)

func produce(key):
	if key in host.account.incident_list : 
		push_error("Want produce a produced incident:%s"%key)
	else:
		print("Produce incident:%s"% value(key))
		host.account.incident_list.append(key)
		_remain_list.erase(key)
