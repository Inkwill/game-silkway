extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBox.message(gameManager.current_scene.name)
	$bg/Button.text = gameManager.current_player.gold as String

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	gameManager.current_player.gold += 1
	#gameManager.current_player.set("gold", gameManager.current_player.gold +1)
	$bg/Button.text = gameManager.current_player.gold as String
