extends Brain
class_name PlayerBrain

var last_checkpoint: Checkpoint
var light_tween: Tween

func move(_entity: Entity, _delta: float) -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_up', 'move_down').normalized()

func died() -> void:
	if get_parent() is Entity:	
		if last_checkpoint:
			print('Reviving at level ' + str(last_checkpoint.level))
			get_parent().reset(last_checkpoint.global_position)

func set_light(on: bool) -> void:
	# Kill existing tween
	if light_tween:
		light_tween.kill()
	
	var target_energy = 1.5 if on else 0.0

	light_tween = create_tween()
	light_tween.tween_property($Light, "energy", target_energy, 0.5)

func set_checkpoint(cp: Checkpoint) -> void:
	last_checkpoint = cp

func end_game() -> void:
	$GameOver.visible = true
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		$PauseMenu.visible = !get_tree().paused
		get_tree().paused = !get_tree().paused
