extends Control

var account 
var player
var world
var date

const _path_ui_action = "res://gui/ui_action/ui_action.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	account = host.account
	player = account.player
	world = account.world
	date = account.date
	
	if player.assetid == -1:
		Effect.new("gain",account.asseter.create_member()).at(player)
	$bt_move.connect("pressed",self,"move")
	refresh()

func move():
	host.goto_scene("res://scene/map.tscn")

func refresh():
	print("refresh")
	print(account.curday)
	$Button.text = account.curday as String
	$bt_Date.text = date.full_name(account.curday)
	$lb_gold.text = GameDate.get_time_name(account.curday)
#	$Viewport/background/DirectionalLight.light_energy = GameDate.get_time(account.curday)/6.0
	
func _on_Button_pressed():
	date.run_time(0.1)
	var eff = Effect.new("add",{"gold":1})
	eff.at(account.asseter.members.values())
	if $bg2.scale_factor == Vector2(1,1): $bg2.zoom(Vector2(0.5,0.5))
	else : $bg2.zoom(Vector2(1,1))
	refresh()
#	var uiaction = load(_path_ui_action).instance()
#	uiaction.action = Action.new(1)
#	host.root.add_child(uiaction)

func _on_bt_Date_pressed():
	var d = GameDate.date_from_juliandate(account.curday)
	MessageBox.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])

func _exit_tree():
	pass

