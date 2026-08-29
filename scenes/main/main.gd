extends Node

@export var songs: Array[AudioStream]

func start_level(level: int):
	# Don't start the game if there already is one active
	for c in get_children():
		if c.name.begins_with("Game"):
			return
	
	print("Starting from level " + str(level))
	var world_scene = load('res://scenes/world/world.tscn').instantiate()
	world_scene.name = "Game"
	add_child(world_scene)
	await world_scene.set_level(level)
	$MainMenu.hide()

func main_menu() -> void:
	for c in get_children():
		if c is World:
			c.queue_free()
	
	$MainMenu.show()

var music_tween: Tween
var current_song := ""

func set_music(song_name: String) -> void:
	if song_name == current_song:
		return
	
	if music_tween:
		music_tween.kill()
	
	music_tween = create_tween()
	music_tween.tween_property($Music, "volume_linear", 0, 2)
	await music_tween.finished
	for song in songs:
		if song.resource_path.get_file().get_basename() == song_name:
			$Music.stream = song
			$Music.play()
			break
	music_tween = create_tween()
	music_tween.tween_property($Music, "volume_linear", 1, 2)
