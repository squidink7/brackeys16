extends Node2D

func open_door(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		$AnimationPlayer.play("DoorOpen")
		body.get_brain().active = false
		await $AnimationPlayer.animation_finished
		
		body.set_deferred("freeze", true)
		await get_tree().process_frame
		body.linear_velocity = Vector2.ZERO
		var tween = body.create_tween()
		tween.tween_property(body, "global_position", $Door.global_position, 5)
		$Door/Front.z_index = 2
		await tween.finished
		$AnimationPlayer.play_backwards("DoorOpen")
		await $AnimationPlayer.animation_finished

		$/root/Main.main_menu()
