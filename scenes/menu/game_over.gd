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

func _process(_delta: float) -> void: 
	%PointLight2D.global_position = $"SubViewportContainer/SubViewport".get_mouse_position()
