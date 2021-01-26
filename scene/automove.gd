extends Sprite

onready var camera = $"../../Camera2D"


func _process(delta):
	if camera == null : return
	if position.x < 600:
		position.x += delta * 50.0
		if position.x - camera.position.x > 240:
			camera.position.x += delta * 50.0
	else:
		position.x = 0
		camera.position.x =0
