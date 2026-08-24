extends Resource
class_name SaveData

var level_records = {}

func set_level_record(level: int, record: LevelRecord):
	if !(level in level_records):
		level_records[level] = record
		return
	
	level_records[level].best_time = min(level_records[record].best_time, record.best_time)
	level_records[level].friends_encountered = max(level_records[record].friends_encountered, record.friends_encountered)
	level_records[level].total_attempts += record.total_attempts
	level_records[level].deaths += record.deaths
