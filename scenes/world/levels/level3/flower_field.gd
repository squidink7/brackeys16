extends MultiMeshInstance2D

func _ready() -> void:
	# Position each item randomly on screen
	for i in range(multimesh.instance_count):
		var pos = Vector2(randf_range(-800, 500), randf_range(-150, 150))
		# var pos = Vector2.ZERO
		var xform = Transform2D(randf_range(PI/4, PI/4 + 0.2), pos)
		multimesh.set_instance_transform_2d(i, xform)
