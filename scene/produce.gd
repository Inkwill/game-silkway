extends Control

func _ready():
	host.account.incident.pre_produce()
	var history = History.new("res://resouce/data/place_xihan.res")
