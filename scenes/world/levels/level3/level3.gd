extends Node2D

var kraken_seen := false

func on_kraken_seen() -> void:
	kraken_seen = true
	$Entities/Kraken/Scales.visible = false
	if $/root/Main:
		$/root/Main.set_music("none")

func on_kraken_area_enter(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain && !kraken_seen:
		if $/root/Main:
			$/root/Main.set_music("kraken-breathing")

func on_kraken_area_exited(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		if $/root/Main:
			$/root/Main.set_music("level3")

func on_flower_field_entered(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		if $/root/Main:
			$/root/Main.set_music("flowers")

func on_flower_field_exited(body: Node2D) -> void:
	if body is Entity && body.get_brain() is PlayerBrain:
		if $/root/Main:
			$/root/Main.set_music("level3")
