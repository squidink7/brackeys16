extends Node2D

@export var energy: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	#check if the collision object is the player
	if body is Eel:
		var brain: PlayerBrain = body.get_brain()
		brain.add_battery(energy)
		
		
		
		
