class_name Entity
extends RigidBody2D

@export var speed = 500.0

var brain: Brain = null

func get_brain() -> Brain:
	if brain != null:
		return brain
	for child in get_children():
		if child is Brain:
			return child
	return null

func _physics_process(delta: float) -> void:
	if get_brain() == null: return
	
	apply_central_force(get_brain().move(self, delta) * speed)
