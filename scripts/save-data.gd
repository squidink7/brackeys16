extends Resource
class_name SaveData

const save_path = 'user://data.json'

@export var current_level: int = 0
@export var unlocked_levels: int = 0
@export var level_records: Dictionary = {}

func set_level_record(level: int, record: LevelRecord):
	if !(level in level_records):
		level_records[level] = record
		return
	
	level_records[level].best_time = min(level_records[level].best_time, record.best_time)
	level_records[level].friends_encountered = max(level_records[level].friends_encountered, record.friends_encountered)
	level_records[level].total_attempts += record.total_attempts
	level_records[level].total_deaths += record.total_deaths

func set_current_level(level: int):
	if level > current_level:
		current_level = level
	
	if level > unlocked_levels:
		print('New level unlocked: ' + str(level))
		unlocked_levels = level
