extends Node2D

var started = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if !started:
			started = true
			start()

func start():
	%StartLabel.hide()
	%Balloon.global_position = %MouseFollow.global_position
	%Balloon.show()
	%Balloon.freeze = false
	%Rope.show()
