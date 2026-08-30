extends Node2D

signal seen
var activated: bool = false

func body_enter(_body: Node2D):
	if !activated:
		activated = true
		%KrakenAnimation.play("disappear")
		seen.emit()

func _process(delta: float) -> void:
	for player in $DetectionArea.get_overlapping_bodies():
		if player is Entity && player.get_brain() is PlayerBrain:
			%Eye.rotation.x = -($DetectionArea.global_position.y - player.global_position.y) / 4096
			%Eye.rotation.y = -($DetectionArea.global_position.x - player.global_position.x) / 4096