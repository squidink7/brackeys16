extends Brain
class_name PlayerBrain

var last_checkpoint: Checkpoint
var light_tween: Tween

func move(_entity: Entity, _delta: float) -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_up', 'move_down').normalized()

func died(entity: Entity) -> void:
	if last_checkpoint:
		print('Reviving at level ' + str(last_checkpoint.level))
		entity.reset(last_checkpoint.global_position)

func set_light(on: bool) -> void:
	# Kill existing tween
	if light_tween:
		light_tween.kill()
	
	var target_energy = 1.5 if on else 0.0

	light_tween = create_tween()
	light_tween.tween_property($Light, "energy", target_energy, 0.5)