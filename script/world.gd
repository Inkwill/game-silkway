extends Object
class_name GameWorld

const begin := {"year":-220,"month":11,"day":14} # 秦始皇帝 二十七年 辛巳年 十月 一日 1641025
const end := {"year":266,"month":2,"day":8} # 西晉武帝 泰始元年 乙酉年 十二月 十七日 1818253
const startDate := {"year":-140,"month":11,"day":01} # 西漢武帝 建元元年 辛丑年 十月 一日 1670231

func _init():
	host.account.curday = max(GameDate.get_juliandate(startDate),host.account.curday)
