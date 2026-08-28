extends Node2D

func _ready() -> void:
	$ExitAnimation.play("RESET")

func on_exit_area_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		$ExitAnimation.play("HideExit")

func on_ambush_area_entered(body: Node2D) -> void:
	pass