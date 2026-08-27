extends Entity
class_name Submarine

var frame: float = 0.0
var frames_count: int = 0
var energy: int
@export var max_energy: int = 100

func _ready() -> void:
	energy = max_energy

	frames_count = $Sprites.get_child_count()

func take_damage(damage: int) -> void:
	energy -= damage
	var changed_color = modulate
	modulate = Color.from_hsv(changed_color.h, changed_color.s, changed_color.v - 1, changed_color.a)

func add_energy(amount: int) -> void:
	energy += amount

func _physics_process(delta: float) -> void:
	super(delta)

	var current_speed = abs(linear_velocity.x) / 64
	frame += current_speed
	while frame > frames_count:
		frame -= frames_count

	for i in frames_count:
		$Sprites.get_child(i).visible = i == int(frame)
