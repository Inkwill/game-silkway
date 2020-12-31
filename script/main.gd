extends Node2D
const account = preload("res://resouce/account.tres")


export(Font) var font
# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBox.message(account.name)
	$bg/Button.text = account.world.curDate as String
	$bg/lb_gold.text = account.curplayer.gold as String
	$bg/bt_Date.text = account.world.get_datename(account.world.curDate)
	print(GameWorld.get_from_juliandate(account.world.curDate))


func _on_Button_pressed():
	var player = account.curplayer
	var world = account.world
	player.gold += 1
	world.curDate += 36500
	$bg/Button.text = world.curDate as String
	$bg/bt_Date.text = world.get_datename(account.world.curDate)
	$bg/lb_gold.text = account.curplayer.gold as String


func _on_bt_Date_pressed():
	var date = GameWorld.get_from_juliandate(account.world.curDate)
	MessageBox.message("%s-%s-%s" % [date["year"],date["month"],date["day"]])
