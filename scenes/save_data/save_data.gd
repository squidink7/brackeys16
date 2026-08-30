extends Node
class_name SaveDataNode

const save_path = 'user://data.res'
var save_data: SaveData = null

# Returns the save data if it can be found, or creates a new instance if not.
func get_save_data() -> SaveData:
	if !save_data:
		if ResourceLoader.exists(save_path):
			save_data = ResourceLoader.load(save_path) as SaveData
	
	if !save_data:
		save_data = SaveData.new()

	return save_data

func set_level_record(level: int, record: LevelRecord) -> void:
	var data = get_save_data()
	data.set_level_record(level, record)
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
	
	save_data = SaveData.new()

func write_save_data():
	ResourceSaver.save(get_save_data(), save_path)

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

# In-game progress tracking
var current_level := 0
var current_level_start_time := Time.get_ticks_msec()
var current_level_record := LevelRecord.new()

func checkpoint_activated(level: int) -> void:
	if level > current_level:
		# Save existing level record
		current_level_record.best_time = Time.get_ticks_msec() - current_level_start_time
		current_level_record.total_attempts = 1
		set_level_record(current_level, current_level_record)
		print("Level complete in " + str(current_level_record.best_time/1000.0) + " seconds")

	# Reset level timer
	current_level = level
	current_level_start_time = Time.get_ticks_msec()
	current_level_record = LevelRecord.new()

func friend_encountered():
	current_level_record.friends_encountered += 1

func died():
	current_level_record.total_deaths += 1

func total_friends_encountered() -> int:
	var total_friends_seen := 0
	for r in save_data.level_records:
		total_friends_seen += save_data.level_records[r].friends_encountered
	return total_friends_seen
