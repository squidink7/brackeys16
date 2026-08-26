extends Node2D

signal seen

func body_enter(body: Node2D):
	$KrakenAnimation.play("disappear")
	seen.emit()