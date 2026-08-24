extends Node

#Redirect to lighting prototype scene
''' 
func start_level(level: int):
	var world_scene = load('res://scenes/world/world.tscn').instantiate()
	world_scene.set_level(level)
	add_child(world_scene)
	$MainMenu.hide()
'''

func start_level(level: int):
	var lighting_scene = load('res://scenes/world/lighting_prototype.tscn').instantiate()
	add_child(lighting_scene)
	$MainMenu.hide()
