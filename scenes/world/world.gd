extends Node2D
class_name World

@export var player_scene: PackedScene
@export var player_brain_scene: PackedScene

var current_level: int = 0
var loaded := false

func _ready() -> void:
	$Darkness.visible = true

func set_level(level: int = -1):
	if level == -1:
		level = current_level
	
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
			entity.queue_free()
	
	# Wait for level to load
	$Levels.get_child(level).load_level()
	await $Levels.get_child(level).loaded

	var player := player_scene.instantiate()
	var player_brain := player_brain_scene.instantiate()
	add_child(player)
	player.add_child(player_brain)
	player.reset(checkpoint.global_position)

func checkpoint_reached(level: int):
	if level >= current_level:
		current_level = level
		$/root/Main/SaveData.set_level(level)

func level_loaded(level: int):
	if level == current_level:
		loaded = true
