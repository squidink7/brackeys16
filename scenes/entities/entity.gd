class_name Entity
extends RigidBody2D

@export var speed = 500.0

var brain: Brain = null

func get_brain() -> Brain:
	if brain:
		return brain
	for child in get_children():
		if child is Brain:
			brain = child
	return brain

func _physics_process(delta: float) -> void:
	if get_brain() == null: return
	
	apply_central_force(get_brain().move(self, delta) * speed)

func kill() -> void:
	if get_brain():
		get_brain().died(self)

func reset(new_position: Vector2) -> void:
	# 1. Clear velocities immediately
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
	# 2. Freeze the body so the physics server stops controlling it
	set_deferred("freeze", true)
	# 3. Safely update the position
	set_deferred("global_position", new_position)
	# 4. Unfreeze the body to hand control back to the engine
	set_deferred("freeze", false)
