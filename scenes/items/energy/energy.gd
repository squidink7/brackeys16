extends Node2D

@export var energy: int = 30
var used := false

func _on_area_2d_body_entered(body: Node2D) -> void:
	#check if the collision object is the Submarine
	if body is Submarine && !used:
		body.add_energy(energy)
		used = true
		queue_free()

		
