extends MeshInstance

func _process(delta):
	translate_object_local(transform.basis.x * delta *0.1)
	if translation.x >= 0.66 :
		translation.x = -0.66
