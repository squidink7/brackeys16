extends Node
class_name SaveDataNode

const save_path = 'user://data.json'
var save_data: SaveData = null

# Returns the save data if it can be found, or creates a new instance if not.
func get_save_data() -> SaveData:
	if !save_data:
		var data = JSON.parse_string(load_file(save_path))
		if data == null:
			save_data = SaveData.new()
		else:
			save_data = SaveData.from_dict(data)

	return save_data

func set_level_record(level: int, record: LevelRecord) -> void:
	var data = get_save_data()
	data.set_level_records(level, record)
	write_save_data()

func unlocked_level(level: int) -> void:
	print('New level unlocked: ' + str(level))
	var save_data = get_save_data()
	save_data.unlock_level(level)
	write_save_data()

func delete_data():
	if FileAccess.file_exists(save_path):
		var error = DirAccess.remove_absolute(save_path)
		if error == OK:
			print("Save deleted")
		else:
			print("Failed to delete save, Error code: ", error)
	else:
		print("No data to reset")

func write_save_data():
	var json = JSON.stringify(get_save_data().to_dict())
	save_file(save_path, json)

# File save/load. Should probably be built-in to the engine, maybe make a PR later.
func load_file(path: String) -> String:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		return content
	else:
		return ""

func save_file(path: String, data: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	# Check if the file opened successfully to prevent null reference crashes
	if file:
		file.store_string(data)
		file.close()
	else:
		print("Failed to write save, Error code: ", FileAccess.get_open_error())
