extends Node2D

var account 
var player
var world

var date = GameDate.new()
var thread
const _path_ui_action = "res://gui/ui_action/ui_action.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	account = host.account
	player = account.curplayer
	world = account.world
	
	if player.assetid == -1:
		Effect.new("gain",account.asseter.create_member()).at(player)
	thread = Thread.new()
	thread.start(self, "_thread_function","Wafflecopter")
	$Sprite.texture = $Viewport.get_texture()
	refresh()

func refresh():
	$Button.text = account.curday as String
	$bg/bt_Date.text = date.full_name(account.curday)
	$bg/lb_gold.text = GameDate.get_time_name(account.curday)
	
func _on_Button_pressed():
	account.curday  += 0.1
	print(account.curday)
	var eff = Effect.new("add",{"gold":1})
	eff.at(account.asseter.members.values())
#	var uiaction = load(_path_ui_action).instance()
#	uiaction.action = Action.new(1)
#	host.root.add_child(uiaction)
	refresh()

func _on_bt_Date_pressed():
	var d = GameDate.date_from_juliandate(account.curday)
	MessageBox.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])

	
func _thread_function(userdata):
	print("i'm a thread! Userdata is: ", userdata)

func _exit_tree():
	thread.wait_to_finish()

