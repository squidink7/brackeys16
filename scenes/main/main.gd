extends Node

func start_level(level: int):
	print("Starting from level " + str(level))
	var world_scene = load('res://scenes/world/world.tscn').instantiate()
	world_scene.name = "Game"
	add_child(world_scene)
	await world_scene.set_level(level)
	$MainMenu.hide()

func main_menu() -> void:
	for c in get_children():
		if c is World:
			c.queue_free()
	
	$MainMenu.show()
