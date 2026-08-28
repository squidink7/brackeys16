class_name AmbushBrain
extends Brain

var seen := false
var on_screen := true

func move(_entity: Entity, delta: float) -> Vector2:
	if !seen || !on_screen:
		# Idle
		return Vector2.ZERO
	
	# If seen, use pathfinding to dash/swim to the end of the level while waiting for the player to catch up.
	return global_position.direction_to($Navigation.get_next_path_position()).normalized()

func on_screen_exit() -> void:
	on_screen = false


func on_seen(body: Node2D) -> void:
	if body is Entity and body.get_brain() is PlayerBrain:
		seen = true
		
		if get_node_or_null("/root/Main/Game/WorldEnd") is Node2D:
			$Navigation.target_position = $/root/Main/Game/WorldEnd.global_position
		else:
			print("Cannot find world end")
			$Navigation.target_position = Vector2.ZERO

func on_screen_enter() -> void:
	on_screen = true
