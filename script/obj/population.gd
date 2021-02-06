extends JSONRes
class_name Population

var natural_mortality:float	#自然死亡率->老年人
var abnormal_mortality:float	#非正常死亡率->青壯年
var infant_mortality:float	#夭折率->嬰幼兒
var birth_rate:float	#嬰兒出生率

var ethnic_composition:Dictionary	#種族構成 
var age_composition:= {"old":0,"adult":0,"infant":0}	#年齡構成
var aero_composition:Dictionary	#地域構成

var number:float #數量
var satiety:float #飽食度 0~100

func _init(_listener=null,_data=null).(_listener,_data):
	pass

func _init_data(id):
	var data = host.account.aeroer.aero_data.value(id)
	natural_mortality = 0.1
	abnormal_mortality = 0.05
	infant_mortality = 0.1
	birth_rate = 0.35
	var init_num = int(data["population"]) * 10000
	_add("old",init_num * 0.3)
	_add("adult",init_num * 0.5)
	_add("infant",init_num * 0.2)
	return _store_data()

func increase(): #by year
	_add("old",-1*natural_mortality)
	_add("adult",-1*abnormal_mortality)
	_add("infant",-1*infant_mortality)
	_add("infant",birth_rate)
	owner.emit_signal("_s_gameobj_changed",owner,"population_increase",self)
	printerr("increase")
	return number
	
func immigrant(num): #int:number float:rate ->青壯年 
	_add("adult",num)
	
func _add(age,num):
	if num is float and num<1: num = age_composition[age] * num
	age_composition[age] = max(0, num + age_composition[age])
	number = max(0,number + num)
	
func _to_string():
	return "Population:%s"% [age_composition]
	
