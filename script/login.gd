extends Node2D


onready var tween = $Tween
var tweentime = 2.0

enum LoginState {
PRELUDE = 0
#The first view of game, include an introductory piece of music and a background representing a typical art style 

READY = 1
#Dispay the information of current player, the button of functions outside the game
}
var state = LoginState.PRELUDE

# Called when the node enters the scene tree for the first time.
func _ready():
	Gamemanager.message(get_tree().current_scene.name)
	Gamemanager.player = Player.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if state == LoginState.PRELUDE:
		$Label.text = str($bg/start.rect_position)


func _on_start_pressed():
	match state:
		LoginState.PRELUDE:
			play_background_tween()
			tween.interpolate_callback(self,tweentime*0.3,"play_button_tween")
		LoginState.READY :
			Gamemanager.goto_scene("res://scene/main.tscn")

func play_background_tween():
	tween.interpolate_property($bg,"rect_position:y",$bg.rect_position.y, -730, tweentime,Tween.TRANS_QUINT, Tween.EASE_OUT)
	if not tween.is_active():
		tween.start()

func play_button_tween():
	tween.interpolate_property($bg/start,"rect_position:y",$bg/start.rect_position.y, 1460, tweentime,Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	if not tween.is_active():
		tween.start()


func _on_Tween_tween_all_completed():
	state = LoginState.READY
	Gamemanager.message("Player: %s Ready!" % Gamemanager.player.name)
