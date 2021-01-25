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
signal timer_end

func _init(p_file = _path,indexs :=["first","last"]).(p_file,indexs):
	pass

func add_action(_action):
	if _action in action_list : push_warning("Add a existed action : %s" % _action)
	else : action_list.append(_action)
	var err = connect("timer_step",_action,"_on_timer_step")
	if err : push_error("GameDate connect _on_timer_step err[%s] to %s" % [err,_action])
	else :err = connect("timer_end",_action,"_on_timer_end")
	if err : push_error("GameDate connect _on_timer_end err[%s] to %s" % [err,_action])
	if not is_running : run_timer(timer_interval)

func remove_action(_action):
	if not _action in action_list : return
	else : action_list.erase(_action)
	if is_connected("timer_step",_action,"_on_timer_step"): disconnect("timer_step",_action,"_on_timer_step")
	else :push_error("GameDate disconnect _on_timer_step err to %s" % _action)
	if is_connected("timer_end",_action,"_on_timer_end"): disconnect("timer_end",_action,"_on_timer_end")
	else: push_error("GameDate disconnect _on_timer_end err to %s" % _action)

func run_timer(delta):
	is_running = true
	_duration = 0.0
	step_timer(delta)

func step_timer(delta):
	yield(host.get_tree().create_timer(timer_unit*delta),"timeout")
	_duration += delta
	host.account.curday += delta/12.0
#	print("timer step,duration = %s" % _duration)
	emit_signal("timer_step",delta)
	
	if action_list.size() > 0 and is_running: step_timer(delta)
	else : 	
		print("Stop timer,duration = %s" % _duration)
		emit_signal("timer_end",_duration)
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

#static func get_cycle(jdate):
#	match get_time(jdate) :
#		0,1,2,3 : return CycleState.DAY
#		4,5 : return CycleState.DUSK
#		6,7,8,9 : return CycleState.NIGHT
#		10,11: return CycleState.DAWN

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
