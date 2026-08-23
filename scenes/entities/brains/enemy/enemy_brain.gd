extends Brain

func move(_entity: Entity) -> Vector2:
	var minplayerdist = INT32_MAX
	var targetPlayer = null

	for p in $PlayerDetector.get_overlapping_bodies():
		if p is Entity && p.get_brain() is PlayerBrain:
			var dist = p.global_position - global_position
			if dist.length_squared() < minplayerdist:
				targetPlayer = p
				minplayerdist = dist
	
	if targetPlayer:
		return global_position.direction_to(targetPlayer.global_position)

	return Vector2.ZERO
