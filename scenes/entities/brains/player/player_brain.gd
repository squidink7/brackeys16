extends Brain
class_name PlayerBrain

func move(_entity: Entity) -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_up', 'move_down').normalized()
