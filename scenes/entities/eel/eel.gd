extends Entity
class_name Eel

# References to segments and joints
@onready var segments: Array[Node] = []

# Swimming state
var target_y_velocity: float = 0.0

func _ready():
	# Collect all segments and joints
	for child in get_children():
		if child is RigidBody2D:
			segments.append(child)
	
	# Sort segments by their position to ensure correct order
	segments.sort_custom(func(a, b): return a.position.x < b.position.x)

func _physics_process(delta):
	var direction = get_brain().move(self, delta)
	
	if segments.size() == 0:
		return
	
	# Apply swimming force (vertical movement)
	apply_swimming(delta,)
	
	# Apply direction flipping (rotate segments)
	if direction.x < 0:
		apply_direction_flip(true)
	elif direction.x > 0:
		apply_direction_flip(false)
	
	# Apply restoring force to return to straight horizontal
	apply_restore_force(delta)

	apply_central_force(direction * speed)

func apply_swimming(delta: float, direction: int):
	# Create undulating motion - higher segments move opposite to lower ones
	for i in range(segments.size()):
		var segment = segments[i]
		
		# Calculate wave position along the body
		var wave_pos = i / float(segments.size())
		
		# Add some randomness for natural movement
		var time = Time.get_ticks_msec() / 1000.0
		
		# Create sine wave for swimming motion
		var wave_offset = sin(time * 5.0 + wave_pos * PI) * 50.0
		
		# Apply vertical force (opposite direction for tail segments for natural undulation)
		var force_direction = 1.0 if i < segments.size() / 2 else -1.0
		segment.apply_central_force(Vector2(0, wave_offset * force_direction * direction))

func apply_direction_flip(backwards: bool):
	# Flip the entire fish when moving backwards    
	if backwards:
		# Rotate to face backwards
		for segment in segments:
			segment.rotation = lerp_angle(segment.rotation, PI, 0.1)
	else:
		# Face forwards
		for segment in segments:
			segment.rotation = lerp_angle(segment.rotation, 0.0, 0.1)

func apply_restore_force(delta: float):
	# Apply forces to bring segments back to horizontal alignment
	for i in range(segments.size()):
		var segment = segments[i]
		
		# Calculate deviation from horizontal
		var angle_deviation = segment.rotation
		
		# Apply restoring torque to bring back to 0 rotation
		var restoring_torque = -angle_deviation * 10.0
		
		# Apply as angular impulse
		segment.angular_velocity += restoring_torque * delta
		
		# Also apply a small force to keep segments in line
		if i > 0:
			var prev_segment = segments[i - 1]
			var direction_to_prev = (prev_segment.global_position - segment.global_position).normalized()
			segment.apply_central_force(direction_to_prev * 10.0 * 0.5)
