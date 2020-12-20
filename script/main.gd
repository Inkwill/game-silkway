extends Node2D
const account = preload("res://resouce/account.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBox.message(account.name)
	$bg/Button.text = account.current_player.gold as String

func _on_Button_pressed():
	var player = account.current_player
	player.gold += 1
	#gameManager.current_player.set("gold", gameManager.current_player.gold +1)
	$bg/Button.text = account.current_player.gold as String
