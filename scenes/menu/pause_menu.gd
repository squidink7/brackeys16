extends CanvasLayer

signal resumed

func resume() -> void:
	resumed.emit()

func exit() -> void:
	get_tree().paused = false
	$/root/Main.main_menu()

func _process(_delta: float): 
	%PointLight2D.global_position = $PauseMenu/SubViewportContainer/SubViewport.get_mouse_position()
