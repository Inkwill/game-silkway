extends Node2D
var account
var date = GameDate.new("res://resouce/data/chinese_calendar.res")

export(Font) var font
# Called when the node enters the scene tree for the first time.
func _ready():
	account = gameManager.account
	MessageBox.message(account.name)
	$bg/Button.text = account.world.curDay as String
	if not account.curplayer.assets == null:
		$bg/lb_gold.text = account.curplayer.assets as String
	$bg/bt_Date.text = date.full_name(account.world.curDay)
	
func _on_Button_pressed():
	var world = account.world
	world.curDay += 1
	$bg/Button.text = world.curDay as String
	$bg/bt_Date.text = date.full_name(account.world.curDay)

func _on_bt_Date_pressed():
	var d = GameDate.date_from_juliandate(account.world.curDay)
	MessageBox.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])
