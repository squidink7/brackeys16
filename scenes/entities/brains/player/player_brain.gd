extends Brain
class_name PlayerBrain

var last_checkpoint: Checkpoint

func move(_entity: Entity, _delta: float) -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_up', 'move_down').normalized()

func died(entity: Entity) -> void:
	if last_checkpoint:
		print('Reviving at level ' + str(last_checkpoint.level))
		entity.reset(last_checkpoint.global_position)
