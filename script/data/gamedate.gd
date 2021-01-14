extends GameTable
class_name GameDate
var _path := "res://resouce/data/chinese_calendar.res"

func _init(p_file = _path,indexs :=["first","last"]).(p_file,indexs):
	pass

func _confirm_key(_key):
	for i in range(content["last"].size()):
		if int(_key) <= int(content["last"][i]) and int(_key) >= int(content["first"][i]): 
#			print("%s is in (%s,%s,%s)" %  [_key,content["keys"][i],content["first"][i],content["last"][i]])
			return content["keys"][i]
	return _key

func full_name(jdate): # 漢 xx帝 年號xx年 月xx日 
	jdate = round(jdate)
	var datename = value(jdate)
	datename["solar"] =  get_solarterm(jdate)
	datename["day"] = jdate - int(datename["first"]) + 1
	return "%s%s %s%s年 (%s) %s月%s日 %s" %[datename["dynasty"],datename["emperor"],datename["era"],datename["year"],datename["ganzhi"],datename["month_name"],datename["day"],solar_name(datename["solar"])]

static func get_time_name(jdate):
	var name = ["午","未","申","酉","戌","亥","子","丑","寅","卯","辰","巳"]
	return name[int(fmod(jdate,1)*12)]
	
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
	return jdate - get_juliandate({"year":date["year"],"month":1,"day":1})
