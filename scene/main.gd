extends Control

var account 
var player
var aeroer
var date

const _path_ui_action = "res://gui/ui_action/ui_action.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	account = host.account
	player = account.player
	aeroer = account.aeroer
	date = account.date
	
	if player.assetid == -1:
		player.gain(account.asseter.create_member())

	date.connect("timer_step",self,"refresh")
#	$bt_move.connect("pressed",self,"open_move")
	account.curday = 1670231
#	var move = Move.new(host.account.player,{"east":500},true)
#	move.act()
	print(date.full_name(account.curday))
	print("日出:%s"%GameDate.get_time_name(account.aeroer.get_aero().sunrise()/96))
	print("日落:%s"%GameDate.get_time_name(account.aeroer.get_aero().sunset()/96))
	refresh()


func refresh(_delta=null):
	$Button.text = account.curday as String
	$bt_Date.text = date.full_name(account.curday)
	$lb_gold.text = GameDate.get_time_name(account.curday)

	
func _on_Button_pressed():
#	var eff = Effect.new("add",{"gold":1})
#	eff.at(account.asseter.members.values())
#	$bg2.move_content( (randi()%5+2)*100)
	var tex = randi()%7+1
	$Popup/icon.texture = load("res://resouce/icon/icon_00%s.jpg"%tex)
	$Popup/text.text = host.account.trooper.get_member({"name":"武王"}).name#random_text()
	$Popup.popup()
	refresh()
	
#	var uiaction = load(_path_ui_action).instance()
#	uiaction.action = Action.new(1)
#	host.root.add_child(uiaction)

func _on_bt_Date_pressed():
	var d = GameDate.date_from_juliandate(account.curday)
	GUITools.message("%s-%s-%s" % [d["year"],d["month"],d["day"]])
	

func random_text():
	var dic = ["廣成子者，古之仙人也。居崆峒山石室之中。黃帝聞而造焉，曰：「敢問至道之要。」廣成子曰：「爾治天下，雲不待簇而飛，草木不待黃而落，奚足以語至道哉？」",
	"白石生者，中黃丈人弟子也。至彭祖之時，已年二千余歲矣。不肯修升仙之道，但取於不死而已，不失人間之樂，其所據行者，正以交接之道為主，而金液之藥為上也。",
	"一曰九頭，二曰五龍，三曰括堤，四曰合雒，五曰連通，六曰序命，七曰脩飛，八曰因穆，九曰禪通，十曰疏訖。",
	"術字公路，司空逢子，紹之從弟也。以俠氣聞。舉孝廉，除郎中，歷職內外，後為折衝校尉、虎賁中郎將。董卓之將廢帝，以術為後將軍；術亦畏卓之禍，出奔南陽。",
	"先主走青州。青州刺史袁譚，先主故茂才也，將步騎迎先主。先主隨譚到平原，譚馳使白紹。紹遣將道路奉迎，身去鄴二百里，與先主相見。",
	"曹公以江陵有軍實，恐先主據之，乃釋輜重，輕軍到襄陽。聞先主已過，曹公將精騎五千急追之，一日一夜行三百餘里，及於當陽之長坂。先主棄妻子，與諸葛亮、張飛、趙雲等數十騎走，曹公大獲其人衆輜重。",
	"諸葛亮字孔明，琅邪陽都人也。漢司隷校尉諸葛豐後也。父珪，字君貢，漢末為太山郡丞。亮早孤，從父玄為袁術所署豫章太守，玄將亮及亮弟均之官。會漢朝更選朱皓代玄。玄素與荊州牧劉表有舊，往依之。"]
	return dic[randi()%dic.size()]



func _exit_tree():
	pass

