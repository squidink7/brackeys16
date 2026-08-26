extends Entity
class_name Eel

@export var segments: Array[RigidBody2D] = []  # Fill with RigidBody2D segments, head to tail

@export var max_speed := 220.0
@export var thrust := 350.0

@export var straighten_strength := 8.0
@export var swim_strength := 3.0
@export var angular_damping_strength := 0.6

@export var wave_speed := 7.0
@export var wave_phase := 0.75
@export var wave_amplitude := 0.35

# Extra bend when moving vertically.
@export var vertical_flex := 0.002

# Avoid flickering facing when velocity is near zero.
@export var flip_threshold := 12.0

# Optional: physically mirror the tail when direction changes.
# Usually you do NOT need this, but I show how below.
@export var mirror_physics_on_flip := false
@export var pin_joints_to_mirror: Array = []  # Fill with PinJoint2D nodes if needed

var facing := 1.0
var swim_time := 0.0

func _ready() -> void:
	_setup_bodies()
	_update_sprites()

func _physics_process(delta: float) -> void:
	swim_time += delta

	_update_facing()
	_apply_movement(delta)
	_apply_spine_forces(delta)

func _setup_bodies() -> void:
	for body in segments:
		if body:
			body.gravity_scale = 0.0
			body.can_sleep = false

func _update_facing() -> void:
	var vx := linear_velocity.x
	var new_facing := facing

	if vx > flip_threshold:
		new_facing = 1.0
	elif vx < -flip_threshold:
		new_facing = -1.0

	if new_facing != facing:
		facing = new_facing
		_update_sprites()

		# if mirror_physics_on_flip:
		# 	_mirror_physics_pose()


func _update_sprites() -> void:
	for body in segments:
		if not body:
			continue

		var sprite := body.get_node_or_null("Sprite2D") as Sprite2D
		if sprite:
			sprite.flip_h = facing < 0.0

			# Alternative:
			# sprite.scale.x = abs(sprite.scale.x) * facing
			#
			# If your sprite has an offset, you may also need:
			# sprite.offset.x = abs(sprite.offset.x) * facing


func _apply_movement(delta: float) -> void:
	# Replace these action names with your own input actions.
	var input_dir := get_brain().move(self, delta)

	if input_dir.length() > 0.01:
		apply_central_force(input_dir.normalized() * thrust)


func _apply_spine_forces(delta: float) -> void:
	if segments.is_empty():
		return

	var speed := linear_velocity.length()
	var speed01 := 0.0

	if max_speed > 0.0:
		speed01 = clamp(speed / max_speed, 0.0, 1.0)

	var idle_weight := 1.0 - speed01

	# Swim amplitude increases with speed.
	# Add extra flex when moving up/down.
	var amplitude := wave_amplitude * speed01
	amplitude += abs(linear_velocity.y) * vertical_flex

	# Head behavior:
	# - mostly returns to horizontal
	# - allows a little pitch when moving vertically
	var pitch_target = clamp(linear_velocity.y * 0.002, -0.35, 0.35)

	# When the fish is visually mirrored, invert the pitch sign.
	if facing < 0.0:
		pitch_target = -pitch_target

	var head_error := wrapf(pitch_target - rotation, -PI, PI)
	apply_torque(
		head_error * straighten_strength
		- angular_velocity * angular_damping_strength
	)

	# Segment behavior:
	for i in segments.size():
		var body: RigidBody2D = segments[i]
		if not body:
			continue

		var previous: RigidBody2D
		if i == 0:
			previous = self
		else:
			previous = segments[i - 1]

		if not previous:
			continue

		# Current bend relative to previous segment.
		var relative_angle := wrapf(body.rotation - previous.rotation, -PI, PI)

		# Make the wave stronger toward the tail.
		var taper := float(i + 1) / float(segments.size())

		# Wave travels down the spine.
		var phase := swim_time * wave_speed - float(i + 1) * wave_phase

		# Mirror the wave when facing changes.
		var target_relative_angle := facing * amplitude * taper * sin(phase)

		var swim_error := wrapf(target_relative_angle - relative_angle, -PI, PI)

		# When idle, pull body back to horizontal.
		var straight_error := wrapf(0.0 - body.rotation, -PI, PI)

		var torque := 0.0

		# Swimming bend.
		torque += swim_error * swim_strength * speed01

		# Idle straightening.
		torque += straight_error * straighten_strength * idle_weight

		# Damping.
		torque -= body.angular_velocity * angular_damping_strength

		body.apply_torque(torque)
