extends Node2D
class_name World

var current_level: int = 0

func _ready() -> void:
	$Darkness.visible = true

func set_level(level: int):
	var checkpoints_parent = get_node_or_null("Checkpoints")
	if !checkpoints_parent:
		print('Unable to find checkpoints')
		return
	var checkpoints = checkpoints_parent.get_children()
	var checkpoint: Checkpoint

	for n in checkpoints:
		if n.level == level:
			checkpoint = n
			break

	if level > len(checkpoints):
		print('Invalid level: ' + str(level))
		return

	current_level = level
	for entity in get_children():
		if entity is Entity && entity.get_brain() is PlayerBrain:
			entity.reset(checkpoint.global_position)
			return
	
	print('Unable to find player to restore')

func checkpoint_reached(level: int):
	if level >= current_level:
		current_level = level
		$/root/Main/SaveData.set_level(level)
