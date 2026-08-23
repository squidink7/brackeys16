extends Area2D

signal reached(level: int)

@export var level: int = 0

func on_body_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		reached.emit(level)