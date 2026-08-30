extends Node2D

var exit_hidden := false

func _ready() -> void:
	$ExitAnimation.play("RESET")

func on_exit_area_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		if !exit_hidden:
			$ExitAnimation.play("HideExit")
			exit_hidden = true

func on_ambush_area_entered(body: Node2D) -> void:
	if exit_hidden && body is Entity && body.get_brain() is PlayerBrain:
		body.get_brain().active = false
		await get_tree().create_timer(3).timeout
		for e in $AmbushEntities.get_children():
			var tween = e.create_tween()
			tween.tween_property(e, "global_position", body.global_position, 0.75)
		await get_tree().create_timer(0.5).timeout

		$/root/Main.main_menu()
