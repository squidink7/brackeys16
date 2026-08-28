extends Entity
class_name Submarine

var frame: float = 0.0
var frames_count: int = 0
var energy: int
@export var max_energy: int = 100

func _ready() -> void:
	energy = max_energy

	frames_count = $Visuals/Sprites.get_child_count()


func take_damage(damage: int) -> void:
	energy -= damage
	var changed_color = modulate
	if energy <= 0:
		if get_brain() is PlayerBrain:
			get_brain().end_game()
			
		return	
	modulate = Color.from_hsv(changed_color.h, changed_color.s, changed_color.v - 0.01, changed_color.a)

func add_energy(amount: int) -> void:
	energy += amount

func toggle_light():
	pass
func _physics_process(delta: float) -> void:
	super(delta)
	take_damage(0.000001)
	var current_speed = abs(linear_velocity.x) / 64
	frame += current_speed
	while frame > frames_count:
		frame -= frames_count

	for i in frames_count:
		$Visuals/Sprites.get_child(i).visible = i == int(frame)

	$Visuals.rotation = lerp_angle($Visuals.rotation, linear_velocity.y / 512, 0.1)
