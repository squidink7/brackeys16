class_name RotationLimiter
extends RefCounted

const MAX_ANGLE = deg_to_rad(35)

# Controls the rotation of the entities rigidbodys'
static func clamp_rotation(state: PhysicsDirectBodyState2D) -> void:
	var current_rot = state.transform.get_rotation()
	
	if current_rot > MAX_ANGLE:
		state.transform = Transform2D(MAX_ANGLE, state.transform.origin)
		if state.angular_velocity > 0:
			state.angular_velocity = 0
	elif current_rot < -MAX_ANGLE:
		state.transform = Transform2D(-MAX_ANGLE, state.transform.origin)
		if state.angular_velocity < 0:
			state.angular_velocity = 0
