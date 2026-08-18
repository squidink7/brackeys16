extends Path2D


func spawn_knife() -> void:
	var newknife = $"../Knife".duplicate()
	newknife.name = "Knife"
	add_child(newknife)
	
	$PathFollow.progress_ratio = randf_range(0, 1)
	
	newknife.global_position = $PathFollow.global_position
	newknife.freeze = false