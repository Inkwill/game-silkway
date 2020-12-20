extends Node2D
const account = preload("res://resouce/account.tres")
export(Font) var font
# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBox.message(account.name)
	$bg/Button.text = account.curplayer.gold as String

func _on_Button_pressed():
	var player = account.curplayer
	player.gold += 1
	#gameManager.current_player.set("gold", gameManager.current_player.gold +1)
	$bg/Button.text = account.curplayer.gold as String
