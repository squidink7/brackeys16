extends Node2D

## TODO: World logic
# Create regions labelled as level start checkpoints, implement method to jump to each checkpoint on death/load.

@export var checkpoints: Array[Node2D] = []

var current_level: int = 0

func set_level(level: int):
	if level <= len(checkpoints):
		print('Invalid level: ' + str(level))
		return

	current_level = level
	for entity in get_children():
		if entity is Entity && entity.get_brain() is PlayerBrain:
			entity.reset(checkpoints[level].global_position)

func checkpoint_reached(level: int):
	if level >= current_level:
		current_level = level