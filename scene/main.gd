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

	date.connect("timer_step",self,"refresh")
	$bt_move.connect("pressed",self,"open_move")
	account.curday = 1670231
	print(account.world.get_aero().sunshine_time())
	print(GameDate.get_time_name(account.world.get_aero().sunrise()/96))
	print(GameDate.get_time_name(account.world.get_aero().sunset()/96))
	refresh()


func refresh(_delta=null):
	$Button.text = account.curday as String
#	$lb_date.text = date.full_name(account.curday)
#	$lb_gold.text = GameDate.get_time_name(account.curday)
#	$Viewport/background/DirectionalLight.light_energy = GameDate.get_time(account.curday)/6.0
	
func _on_Button_pressed():
	var eff = Effect.new("add",{"gold":1})
	eff.at(account.asseter.members.values())
	$bg2.move_content( (randi()%5+2)*100)
	refresh()
	
#	var uiaction = load(_path_ui_action).instance()
#	uiaction.action = Action.new(1)
#	host.root.add_child(uiaction)

func _on_bt_Date_pressed():
	var d = GameDate.date_from_juliandate(account.curday)
	MessageBox.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])

func open_move():
	var winMap = load("res://scene/map.tscn").instance()
	add_child(winMap)
	$bg2.move_content(-60)
	
func _exit_tree():
	pass

