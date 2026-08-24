extends Brain
class_name PlayerBrain

var last_checkpoint: Checkpoint

func move(_entity: Entity, delta: float) -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_up', 'move_down').normalized()

func revive() -> void:
	if last_checkpoint:
		print('Reviving at level ' + str(last_checkpoint.level))
		get_entity().reset(last_checkpoint.global_position)
