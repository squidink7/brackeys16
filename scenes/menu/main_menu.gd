extends Control

signal start_level(level: int)

func new_game_pressed() -> void:
	print('New game')
	start_level.emit(0)

func continue_pressed() -> void:
	var data = %SaveData.get_save_data()
	
	if !data:
		print('New game (no save data)')
		start_level.emit(0)
		return
	
	start_level.emit(len(data.level_records))

func play_pressed() -> void:
	start_level.emit(0)

func reset_pressed() -> void:
	%SaveData.delete_data()

func _process(_delta: float) -> void:
	%PointLight2D.global_position = get_viewport().get_mouse_position()
