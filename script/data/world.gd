extends Resource
class_name GameWorld
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db_name := "res://resouce/db/chinese_calendar"
var db

const begin := {"year":-220,"month":11,"day":14} # time authority database from : http://authority.dila.edu.tw/
const endDate := {"year":-220,"month":11,"day":14} # 漢武 建元 元年 元月 元日
export(Dictionary) var startDate := {"year":-140,"month":11,"day":01} # 漢武 建元 元年 元月 元日

var curDate := 0 # JulianDate

func _init(p_startDate = {}):
	startDate = p_startDate

static func get_juliandate(date):
	var a = (14 - date["month"])/12
	var y = date["year"] + 4800 - a
	var m = date["month"] + 12*a -3
	return date["day"] + (153*m+2)/5 + 365*y + y/4 -y/100 + y/400 -32045 #格里历
	#return date["day"] + (153*m+2)/5 + 365*y + y/4 -32083 # 儒略历

static func get_from_juliandate(jdate):
	return OS.get_datetime_from_unix_time((jdate - 2440588)* 86400)

static func get_solarterm(jdate) -> String:
	var name = ["冬至","小寒","大寒","立春","雨水","驚蟄","春分","清明","穀雨","立夏","小滿","芒種","夏至","小暑","大暑","立秋","處暑","白露","秋分","寒露","霜降","立冬","小雪","大雪"]
	var year = get_from_juliandate(jdate)["year"]
	var solar_0 = 1721050.5 + 19/32 + (year+1) * 365.25 #冬至
	for i in range(24):
		if jdate == ceil(solar_0 - (i/24.0) * 365.25):return "%s"%name[24-i]
	return ""

	
func get_datename(j_date) -> String: # 漢 xx帝 年號xx年 月xx日 
	db = SQLite.new()
	db.path = db_name
	db.verbose_mode = true
	db.open_db()
	var datename = {"solar":get_solarterm(j_date)}
	var select_condition : String = "first <= %s AND last >= %s" % [j_date,j_date]
	var selected_array : Array = db.select_rows("t_month", select_condition, ["id","first","year","month_name","era_id","ganzhi"])
	if selected_array.size() < 0 :
		return "get date name err : %s" % j_date
	else:
		var month = selected_array[0]
		datename["day"] = j_date - int(month["first"]) + 1
		datename["month"] = month["month_name"] 
		datename["ganzhi"] = month["ganzhi"]
		datename["year"] = month["year"]
		datename["era"] = db.select_rows("t_era_names","ranking == 0 AND era_id == %s" % month["era_id"],["name"])[0]["name"]
		var emperor_id = db.select_rows("t_era","id == %s" % month["era_id"],["emperor_id"])[0]["emperor_id"]
		datename["emperor"] = db.select_rows("t_emperor_names","ranking == 0 AND emperor_id == %s" % emperor_id,["name"])[0]["name"]
		var dynasty_id = db.select_rows("t_emperor","id == %s" % emperor_id,["dynasty_id"])[0]["dynasty_id"]
		print("dynasty_id: %s" % dynasty_id)
		datename["dynasty"] = db.select_rows("t_dynasty_names","dynasty_id == %s" % dynasty_id,["name"])[0]["name"]
	return "%s%s %s%s年 (%s) %s月%s日 %s" %[datename["dynasty"],datename["emperor"],datename["era"],datename["year"],datename["ganzhi"],datename["month"],datename["day"],datename["solar"]]
