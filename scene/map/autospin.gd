extends MeshInstance

func _ready():
	refresh()

func refresh():
	translation = Vector3(0,-1,0)
	rotation_degrees = Vector3(0,0,0)
	scale = Vector3(10,10,10)
	
func _process(delta):
#	translate_object_local(transform.basis.y * delta *0.2)
	var n = 1
	translation.y += delta* 0.1
	if translation.y > 0.7 : 
		rotation_degrees.y = -20
		translation.x += delta * 0.15
		n += n
	rotation_degrees.x -= delta * 200.0
	if translation.y > 1 : 
		refresh()
	scale = Vector3(1,1,1)/(translation.y + n)
	
	$ground.translate_object_local(transform.basis.x * delta *0.1)
	if $ground.translation.x >= 0.66 :
		$ground.translation.x = -0.66
