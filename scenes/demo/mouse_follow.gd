extends AnimatableBody2D

@export
var speed = 100

func _process(delta: float) -> void:
	global_position = global_position.move_toward(get_viewport().get_mouse_position(), speed)
	%Rope.set_point_position(0, global_position)
	%Rope.set_point_position(1, %Balloon/RopeAnchor.global_position)
