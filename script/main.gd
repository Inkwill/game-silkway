extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Gamemanager.message(Gamemanager.current_scene.name)
	$"bg/Button".text = Gamemanager.player.gold as String

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Gamemanager.player.gold += 1
	$"bg/Button".text = Gamemanager.player.gold as String
