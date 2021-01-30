extends GameTable
class_name GameDate

const _path := "res://resouce/data/chinese_calendar.res"
const begin := {"year":-220,"month":11,"day":14,"hour":12} # 秦始皇帝 二十七年 辛巳年 十月 一日 1641025
const end := {"year":266,"month":2,"day":8,"hour":12} # 西晉武帝 泰始元年 乙酉年 十二月 十七日 1818253
const startDate := {"year":-140,"month":11,"day":01,"hour":12} # 西漢武帝 建元元年 辛丑年 十月 一日 午時 1670231
const state_transition_duration := 1.0 
const timer_interval := 0.12 # (大時) 1刻=15min 96刻
const timer_unit := 1 # 秒/大時

var action_list := []
var is_running := false
var _duration := 0.0

signal timer_step
signal day_step
signal moon_step
signal big_hour_step

func _init(p_file = _path,indexs :=["first","last"]).(p_file,indexs):
	pass

func add_action(_action):
	if _action in action_list : push_warning("Add a existed action : %s" % _action)
	else : action_list.append(_action)
	_connect_signals(_action,["timer_step","day_step","moon_step","big_hour_step"])
	if not is_running : run_timer(timer_interval)

func remove_action(_action):
	if not _action in action_list : return
	else : action_list.erase(_action)
	_disconnect_signals(_action,["timer_step","day_step","moon_step","big_hour_step"])

func run_timer(delta):
	is_running = true
	_duration = 0.0
	step_timer(delta)

func step_timer(delta):
	yield(host.get_tree().create_timer(timer_unit*delta),"timeout")
	var last_day = host.account.curday
	_duration += delta
	host.account.curday += delta/12.0
	emit_signal("timer_step",delta)
	
	if is_cross_big_hour(last_day,host.account.curday) : emit_signal("big_hour_step",delta)
	if is_cross_day(last_day,host.account.curday) : emit_signal("day_step",delta)
	if is_cross_moon(last_day,host.account.curday) : emit_signal("moon_step",delta)
	
	if action_list.size() > 0 and is_running: step_timer(delta)
	else : 	
		print("Stop timer,duration = %s" % _duration)
		is_running = false

func get_day(jdate) -> float:
	jdate = jdate
	var datename = value(round(jdate))
	return jdate - int(datename["first"]) + 1

func full_name(jdate): # 漢 xx帝 年號xx年 月xx日 
	jdate = round(jdate)
	var datename = value(jdate)
	datename["solar"] =  get_solarterm(jdate)
	datename["day"] = jdate - int(datename["first"]) + 1
	return "%s%s %s%s年 (%s) %s月%s日 %s" %[datename["dynasty"],datename["emperor"],datename["era"],datename["year"],datename["ganzhi"],datename["month_name"],datename["day"],solar_name(datename["solar"])]

func _confirm_key(_key):
	for i in range(content["last"].size()):
		if int(_key) <= int(content["last"][i]) and int(_key) >= int(content["first"][i]): 
#			print("%s is in (%s,%s,%s)" %  [_key,content["keys"][i],content["first"][i],content["last"][i]])
			return content["keys"][i]
	return _key

func _connect_signals(obj,signals):
	for s in signals :
		var err = connect(s,obj,"_on_%s"%s)
		if err : push_error("Connect %s err[%s] to %s" % [s,err,obj])
		
func _disconnect_signals(obj,signals=null):
	if signals == null : signals = get_signal_list()
	for s in signals :
		if is_connected(s,obj,"_on_%s"%s): disconnect(s,obj,"_on_%s"%s)

static func get_time_name(jdate): # jdate - 12:00   - 午時三刻
	var big_hour_name = ["午","未","申","酉","戌","亥","子","丑","寅","卯","辰","巳"]
	var quarter_name = ["","一刻",'二刻',"三刻","四刻","五刻","六刻","七刻"]
	var big_hour = int(fmod(jdate+1/24.0,1)*12)
	var quarter = int(fmod(jdate+3/96.0,1)*96)
	return big_hour_name[big_hour] + "時" + quarter_name[quarter%8]
	
static func get_juliandate(date):
	var a = (14 - date["month"])/12
	var y = date["year"] + 4800 - a
	var m = date["month"] + 12*a -3
	return date["hour"]/24.0 + date["day"] + (153*m+2)/5 + 365*y + y/4 -y/100 + y/400 -32045.5 #格里历
	#return date["day"] + (153*m+2)/5 + 365*y + y/4 -32083 # 儒略历

static func date_from_juliandate(jdate):
	return OS.get_datetime_from_unix_time((jdate - 2440588)* 86400)

static func get_solarterm(jdate):
	var year = date_from_juliandate(jdate)["year"]
	var solar_0 = 1721050.5 + 19/32 + year * 365.25 #上一個冬至
	var solar = {"id":0,"day":0}
	for i in range(25):
		var day = ceil(solar_0 + (i+1)/24.0 * 365.25) - jdate
		if day >= 0 :
			solar["id"]= i+1 if day == 0 else i
			solar["day"]= 0 if day == 0 else jdate - ceil(solar_0+i/24.0*365.25)
			break
	return solar

static func solar_name(solar)->String:
	var name = ["冬至","小寒","大寒","立春","雨水", "驚蟄", "春分", "清明", "穀雨", "立夏", "小滿","芒種", "夏至", "小暑", "大暑", "立秋", "處暑", "白露", "秋分", "寒露", "霜降", "立冬","小雪","大雪","冬至"]
	if solar["day"]>0 :return "%s(+%s)"% [name[solar["id"]],solar["day"]]
	else : return name[solar["id"]]

static func day_in_year(jdate):
	var date = date_from_juliandate(jdate)
	return jdate - get_juliandate({"year":date["year"],"month":1,"day":1,"hour":0})

static func is_cross_day(last_jdate,new_jdate)->bool:
	if new_jdate-last_jdate-1 >= 0 : return true
	elif fmod(last_jdate,1)-15/32.0 < 0 : return fmod(new_jdate,1)-15/32.0 >=0		#午後子前
	else : return fmod(new_jdate,1)-15/32.0>=0 and fmod(new_jdate,1)<fmod(last_jdate,1) #子後午前

static func is_cross_moon(last_jdate,new_jdate)->bool:
	if new_jdate-last_jdate-1 >= 0 : return true
	return fmod(new_jdate,1)-fmod(last_jdate,1) <0
	

static func is_cross_big_hour(last_jdate,new_jdate)->bool:
	if new_jdate-last_jdate-1/12.0 >= 0 : return true
	else : return int(fmod(last_jdate+1/24.0,1)*12) == int(fmod(new_jdate+1/24.0,1)*12)
