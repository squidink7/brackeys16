extends Node2D

func activate_ending():
	# if $/root/Main/SaveData.friend_encountered() > 0:
	if 1 > 0:
		# Bad end
		$GoodEndSequence.process_mode = Node.PROCESS_MODE_DISABLED
		$GoodEndSequence.visible = false
	else:
		# Good end
		$BadEndSequence.process_mode = Node.PROCESS_MODE_DISABLED
		$BadEndSequence.visible = false


func on_ending_selector_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		activate_ending()
