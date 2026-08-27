extends Brain

var target_entities = []
var last_seen_entity = null
@export var damage: int = 10;

func move(_entity: Entity, _delta: float) -> Vector2:
	if len(target_entities) == 0 && !last_seen_entity:
		# Idle
		return Vector2.ZERO
	else:
		# Seeking entity
		var minplayerdist := INT32_MAX
		var target_pos = last_seen_entity

		for p in target_entities:
			var dist = p.global_position - global_position
			if dist.length_squared() < minplayerdist:
				target_pos = p.global_position
				minplayerdist = dist.length_squared()
		
		$Navigation.target_position = target_pos
		
		return global_position.direction_to($Navigation.get_next_path_position()).normalized()

func seen_entity(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		target_entities.append(body)

func lost_entity(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		target_entities.erase(body)
		if len(target_entities) == 0:
			last_seen_entity = body.global_position
func attack() -> int:
	return damage
	
