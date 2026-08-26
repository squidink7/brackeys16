extends CanvasLayer

func resume() -> void:
	get_tree().paused = false
	hide()

func exit() -> void:
	get_tree().paused = false
	$/root/Main.main_menu()
