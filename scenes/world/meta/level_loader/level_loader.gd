extends Area2D

signal loaded()

@export_file("*.tscn") var scene_path: String
var loading := false

func _process(_delta: float) -> void:
	if not loading:
		return

	var status = ResourceLoader.load_threaded_get_status(scene_path)

	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			# Loading is complete, grab the resource
			loading = false
			
			# Ensure level isn't already loaded
			for c in $Level.get_children():
				c.queue_free()
			
			var packed_scene = ResourceLoader.load_threaded_get(scene_path)
			
			# Instantiate when done
			var instance = packed_scene.instantiate()
			$Level.add_child(instance)

			loaded.emit()
			
		ResourceLoader.THREAD_LOAD_FAILED:
			loading = false
			printerr("Unable to load level " + scene_path + ".")
			
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			loading = false
			printerr("Unable to load level " + scene_path + ": Invalid resource path.")
			
		# THREAD_LOAD_IN_PROGRESS: still loading, do nothing or update a progress bar using progress[0]

func area_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		load_level()

func area_exited(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		unload_level()

func load_level() -> void:
	var err = ResourceLoader.load_threaded_request(scene_path)
	if err == OK:
		loading = true

func unload_level() -> void:
	for c in $Level.get_children():
		c.queue_free()
