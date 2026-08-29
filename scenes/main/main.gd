extends Node

func start_level(level: int):
	# Don't start the game if there already is one active
	for c in get_children():
		if c.name.begins_with("Game"):
			return
	
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
