extends Control

signal start_level(level: int)

func play_pressed() -> void:
	start_level.emit(0)