extends Node2D
var account
var date = GameDate.new("res://resouce/data/chinese_calendar.res")
var thread

export(Font) var font
# Called when the node enters the scene tree for the first time.
func _ready():
	account = host.account
	MessageBox.message(account.name)
	$bg/Button.text = account.curday as String
	if account.curplayer.assetid == -1:
		Effect.new("gain",account.asseter.create_member()).at(account.curplayer)
	$bg/lb_gold.text = str(account.curplayer.asset.data["gold"])
	$bg/bt_Date.text = date.full_name(account.curday)
	var movto = Move.new("moveto",Vector2(30,40))
	movto.at(account.curplayer)
	thread = Thread.new()
	thread.start(self, "_thread_function","Wafflecopter")
	
func _on_Button_pressed():
	account.curday += 1
	var eff = Effect.new("add",{"gold":1})
	eff.at(account.asseter.members.values())
	var mov = Move.new("move",{"westnorth":100})
	mov.at(account.curplayer)
	$bg/Button.text = account.curday as String
	$bg/bt_Date.text = date.full_name(account.curday)
	$bg/lb_gold.text = str(account.curplayer.asset.data["gold"])
#	var a = {"a":1}
#	var b = {"b":2}
#	print(a+b)


func _on_bt_Date_pressed():
	var d = GameDate.date_from_juliandate(account.curday)
	MessageBox.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])

func _thread_function(userdata):
	print("i'm a thread! Userdata is: ", userdata)

func _exit_tree():
	thread.wait_to_finish()

