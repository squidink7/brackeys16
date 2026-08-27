extends Entity
class_name Submarine

var energy: int
@export var max_energy: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	energy = max_energy # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func take_damage(damage: int) -> void:
	energy -= damage
func add_energy(amount: int) -> void:
	energy += amount
	
	
