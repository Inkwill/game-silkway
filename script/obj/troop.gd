extends Actor
class_name Troop

var move_speed :float # km/時辰
var explore :int # round(x^0.478/2) f:[0,5]

func _init(_data).(_data):
	move_speed = 10.0
	explore = 10
