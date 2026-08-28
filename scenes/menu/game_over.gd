extends CanvasLayer
class_name GameOver
signal reset
func resume() -> void:
	reset.emit()
	
	get_tree().paused = false
	hide()

func exit() -> void:
	get_tree().paused = false
	$/root/Main.main_menu()

func _process(delta): 
	%PointLight2D.global_position = get_viewport().get_mouse_position()
