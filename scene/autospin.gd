extends MeshInstance

func _ready():
	print("transform:%s" % transform)

func _process(delta):
	translate_object_local(transform.basis.y * delta *0.2)
	rotate_x(-delta * PI)
