extends Brain

@export var anchor: Node2D

var seen = false
var _angle: float = 0.0
var _time: float = 0.0

@export var radius: float = 100.0        # distance from the anchor
@export var orbit_speed: float = 0.5     # radians per second
@export var drift_amplitude: float = 30.0 # how far it bobs up/down
@export var drift_speed: float = 1.5     # how fast the bobbing happens
@export var steering_strength: float = 0.7  # how quickly it corrects its path
@export var smooth_approach: bool = true  # enable smooth damping near target

func move(_entity: Entity, delta: float) -> Vector2:
	if seen:
		# If seen, use pathfinding to dash/swim to the end of the level and disappear when out of view.
		print(global_position)
		return global_position.direction_to($Navigation.get_next_path_position()).normalized()

	if !anchor:
		return Vector2.ZERO

	# Advance the orbit angle and idle timer.
	_angle += orbit_speed * delta
	_time += delta

	# Position on the circle, with a vertical sine drift on top.
	var target = anchor.global_position + Vector2(
		cos(_angle) * radius,
		sin(_angle) * radius + sin(_time * drift_speed) * drift_amplitude
	)

	# Calculate the vector to target and distance
	var to_target = target - _entity.global_position
	var distance = to_target.length()
	
	if distance < 0.1:
		return Vector2.ZERO
	
	if smooth_approach:
		# Smooth steering with distance-based damping
		# Closer = slower approach, prevents overshooting
		var desired_direction = to_target.normalized()
		
		# Damping factor: approaches 1.0 as we get closer, 
		# but never exceeds 1.0 to prevent acceleration
		var damping = 1.0 - exp(-distance / (radius * 0.5))
		
		# Apply steering strength for responsiveness
		return desired_direction * damping * steering_strength
	else:
		# Original behavior (can cause bouncing)
		return to_target.normalized()



func on_screen_exit() -> void:
	if seen:
		var e = get_entity()
		if e:
			e.queue_free()

func on_seen(body: Node2D) -> void:
	if body is Entity and body.get_brain() is PlayerBrain:
		seen = true
		$Navigation.target_position = Vector2.ZERO
