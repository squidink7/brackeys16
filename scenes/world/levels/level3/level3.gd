extends Node2D

func on_kraken_seen() -> void:
	$Entities/Kraken/Scales.visible = false

func on_kraken_area_enter(body: Node2D) -> void:
	$/root/Main.set_music("kraken")

func on_kraken_area_exited(body: Node2D) -> void:
	$/root/Main.set_music("level3")
