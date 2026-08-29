extends Brain

var target_entities = []
var last_seen_entity = null
var attacked := false
@export var damage: int = 10;

func move(_entity: Entity, _delta: float) -> Vector2:
	if len(target_entities) == 0 && !last_seen_entity:
		# Idle
		return Vector2.ZERO
	elif !attacked:
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
		$AttackTimer.start()

func lost_entity(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		target_entities.erase(body)
		if len(target_entities) == 0:
			last_seen_entity = body.global_position

func attack() -> int:
	attacked = true
	if get_node_or_null("/root/Main/Game/WorldEnd") is Node2D:
		$Navigation.target_position = $/root/Main/Game/WorldEnd.global_position
	else:
		print("Cannot find world end")
		$Navigation.target_position = Vector2.ZERO
	return damage
