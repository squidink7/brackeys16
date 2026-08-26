extends Area2D

func on_enter(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		body.get_brain().set_light(false)

func on_exit(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		body.get_brain().set_light(true)