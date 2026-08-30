extends Control

signal start_level(level: int)

func _ready() -> void:
	update_data()

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
	update_data()

func _process(_delta: float) -> void:
	%PointLight2D.global_position = $SubViewportContainer/SubViewport.get_mouse_position()

func update_data() -> void:
	$Counter.text = "Current Level: " + str(len(%SaveData.get_save_data().level_records)) + "\nGuide encounters: " + str(%SaveData.total_friends_encountered())
