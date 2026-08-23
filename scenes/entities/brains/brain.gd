extends Node2D
class_name Brain

func move(_entity: Entity, _delta: float) -> Vector2:
	return Vector2.ZERO

func get_entity() -> Entity:
	var p = get_parent()
	if p is Entity:
		return p
	return null