extends Actor
class_name Troop

var move_speed :float # km/時辰
var explore :float # long-lat distance

func _init(_data).(_data):
	move_speed = 10.0
	explore = 0.1
