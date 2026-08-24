extends Node

#Redirect to lighting prototype scene
const save_path = 'user://data.json'
var save_data: SaveData = null

func start_level(level: int):
	var world_scene = load('res://scenes/world/world.tscn').instantiate()
	world_scene.set_level(level)
	add_child(world_scene)
	$MainMenu.hide()

# Returns the save data if it can be found, null otherwise.
func get_save_data() -> SaveData:
	if save_data == null:
		save_data = JSON.parse_string(load_text_file(save_path))
	return save_data

func set_level_record(level: int, record: LevelRecord):
	var data = get_save_data()
	data.set_level_records(level, record)
	
func load_text_file(path: String) -> String:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		return content
	else:
		return ""
