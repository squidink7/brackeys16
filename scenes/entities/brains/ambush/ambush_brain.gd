class_name AmbushBrain
extends Brain

func _ready() -> void:
	$Navigation.target_position = $TargetPos.global_position

func move(_entity: Entity, delta: float) -> Vector2:
	for player in $PlayerDetector.get_overlapping_bodies():
		if player is Entity && player.get_brain() is PlayerBrain:
			# If seen, use pathfinding to dash/swim to the end of the level while waiting for the player to catch up.
			return global_position.direction_to($Navigation.get_next_path_position()).normalized() * (global_position - player.global_position).length() / 256
	
	# Idle
	return Vector2.ZERO
	
