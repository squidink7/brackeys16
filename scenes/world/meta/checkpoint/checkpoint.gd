extends Area2D
class_name Checkpoint

signal reached(level: int)

@export var level: int = 0
@export var id: String = ''

func on_body_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		body.get_brain().set_checkpoint(self)
		reached.emit(level)
