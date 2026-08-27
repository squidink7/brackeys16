extends Entity
class_name Eel

func _physics_process(delta: float) -> void:
	# Movement
	var direction = get_brain().move(self, delta)
	apply_central_force(direction * speed)

	# Rotation
	if direction != Vector2.ZERO:
		var angle_diff = angle_difference(rotation, direction.angle())
		apply_torque(angle_diff * speed * 10)

	if $Sprites.scale.y == -1:
		if abs(rotation) < PI/2-0.1:
			$Sprites.scale.y = 1
	elif $Sprites.scale.y == 1:
		if abs(rotation) > PI/2+0.1:
			$Sprites.scale.y = -1

	$Animation.speed_scale = linear_velocity.length() / 64
