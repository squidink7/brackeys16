extends CanvasLayer

signal resumed

func resume() -> void:
	resumed.emit()

func exit() -> void:
	get_tree().paused = false
	$/root/Main.main_menu()

func _process(delta): 
	%PointLight2D.global_position = get_viewport().get_mouse_position()
