extends Node2D
const account = preload("res://resouce/account.tres")
var date

export(Font) var font
# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBox.message(account.name)
	$bg/Button.text = account.world.curDate as String
	$bg/lb_gold.text = account.curplayer.gold as String
	date = GameDate.new("res://resouce/db/chinese_calendar.csv")
	#$bg/bt_Date.text = account.world.get_datename(account.world.curDate)
	$bg/bt_Date.text = date.full_name(account.world.curDate)

func _on_Button_pressed():
	var player = account.curplayer
	var world = account.world
	player.gold += 1
	world.curDate += 1
	$bg/Button.text = world.curDate as String
	#$bg/bt_Date.text = world.get_datename(account.world.curDate)
	$bg/lb_gold.text = account.curplayer.gold as String
	$bg/bt_Date.text = date.full_name(account.world.curDate)


func _on_bt_Date_pressed():
	var d = GameWorld.get_from_juliandate(account.world.curDate)
	MessageBox.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])
