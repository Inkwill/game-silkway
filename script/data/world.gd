extends Resource
class_name GameWorld

export(int) var startDate
export(int) var endDate
export(int) var curDate

func _init(p_startDate = 0,p_endDate = 0, p_curDate = 0):
	startDate = p_startDate
	endDate = p_endDate
	curDate = p_curDate
