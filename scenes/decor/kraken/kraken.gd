extends Node2D

signal seen
var activated: bool = false

func body_enter(_body: Node2D):
	if !activated:
		activated = true
		%KrakenAnimation.play("disappear")
		seen.emit()
