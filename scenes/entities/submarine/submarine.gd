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
	var changed_color_window = $Visuals/SubGlowingWindow.modulate
	var changed_color_point = $PointLight2D.modulate
	if energy <= 0:
		if get_brain() is PlayerBrain:
			get_brain().end_game()
			#TODO: $PointLight2D and SubGLOWING WINDOW nedd to be tied to hp system
		return	
	$Visuals/SubGlowingWindow.modulate = Color.from_hsv(changed_color_window.h, changed_color_window.s, changed_color_window.v - 1, changed_color_window.a)
	$PointLight2D.modulate = Color.from_hsv(changed_color_point.h, changed_color_point.s, changed_color_point.v - 1, changed_color_point.a)
func add_energy(amount: int) -> void:
	energy += amount

func toggle_light():
	pass
func _physics_process(delta: float) -> void:
	super(delta)
	if energy > 10:
		take_damage(delta/2)
	var current_speed = abs(linear_velocity.x) / 64
	frame += current_speed
	while frame > frames_count:
		frame -= frames_count

	for i in frames_count:
		$Visuals/Sprites.get_child(i).visible = i == int(frame)

	$Visuals.rotation = lerp_angle($Visuals.rotation, linear_velocity.y / 512, 0.1)
