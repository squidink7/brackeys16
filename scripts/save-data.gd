extends Resource
class_name SaveData

const save_path = 'user://data.json'

var unlocked_levels = 0
var level_records = {}

func set_level_record(level: int, record: LevelRecord):
	if !(level in level_records):
		level_records[level] = record
		return
	
	level_records[level].best_time = min(level_records[record].best_time, record.best_time)
	level_records[level].friends_encountered = max(level_records[record].friends_encountered, record.friends_encountered)
	level_records[level].total_attempts += record.total_attempts
	level_records[level].deaths += record.deaths

func unlock_level(level: int):
	if level > unlocked_levels:
		unlocked_levels = level

func to_dict() -> Dictionary:
	return {
		'unlocked_levels': unlocked_levels,
		'level_records': level_records
	}

static func from_dict(dict: Dictionary) -> SaveData:
	var sd = SaveData.new()
	sd.unlocked_levels = dict['unlocked_levels']
	sd.level_records = dict['level_records']
	return sd