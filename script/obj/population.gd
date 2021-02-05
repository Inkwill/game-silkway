extends Object
class_name Population

var natural_mortality:float	#自然死亡率->老年人
var abnormal_mortality:float	#非正常死亡率->青壯年
var infant_mortality:float	#夭折率->嬰幼兒
var birth_rate:float	#嬰兒出生率

var ethnic_composition:Dictionary	#種族構成 
var age_composition:Dictionary	#年齡構成
var aero_composition:Dictionary	#地域構成

var number:int #數量
var satiety:int #飽食度 0~100

func _init(_data):
	pass

func increase(): #by year
	pass
	
func move_in(): #int:number float:rate ->青壯年 
	pass
	
func move_out(): #int:number float:rate ->青壯年 
	pass
	
