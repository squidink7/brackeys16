extends Node

func start_level(level: int):
	var world_scene = load('res://scenes/world/world.tscn').instantiate()
	world_scene.name = "Game"
	world_scene.set_level(level)
	add_child(world_scene)
	$MainMenu.hide()

func main_menu() -> void:
	for c in get_children():
		if c is World:
			c.queue_free()
	
	$MainMenu.show()