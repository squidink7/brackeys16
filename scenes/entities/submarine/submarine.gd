extends Entity
class_name Submarine

var frame: float = 0.0
var frames_count: int = 0
var energy: float = 0
@export var max_energy: float = 100

var xscale = 1.0

func _ready() -> void:
	energy = max_energy

	frames_count = $Visuals/Sprites.get_child_count()

func take_damage(damage: float) -> void:
	energy -= damage

	if damage > 0:
		$Animation.play("Attacked")

	if energy <= 0:
		if get_brain() is PlayerBrain:
			get_brain().end_game()
		return

func add_energy(amount: int) -> void:
	energy = min(energy + amount, max_energy)

func toggle_light():
	pass

func _physics_process(delta: float) -> void:
	super(delta)
	if energy > 10:
		energy -= delta/2
	var current_speed = abs(linear_velocity.x) / 64
	
	frame += current_speed

	while frame > frames_count:
		frame -= frames_count

	for i in frames_count:
		$Visuals/Sprites.get_child(i).visible = i == int(frame)

	# Sprite flip
	if xscale > 0:
		if linear_velocity.x < -15:
			xscale = -1
	elif xscale < 0:
		if linear_velocity.x > 15:
			xscale = 1
	
	$Visuals.scale.x = lerpf($Visuals.scale.x, xscale, delta*10)

	$Visuals.rotation = lerp_angle($Visuals.rotation, linear_velocity.y / 512 * xscale, delta*4)

	$Visuals/Bubbles.emitting = abs(linear_velocity.x) > 10

func _process(delta: float) -> void:
	%SubGlowingWindow.modulate.v = lerpf(%SubGlowingWindow.modulate.v, 5 * energy / max_energy, delta*8)
	%FrontLight.modulate.v = lerpf(%FrontLight.modulate.v, energy / max_energy, delta*2)

func reset(new_position: Vector2) -> void:
	super(new_position)

	energy = max_energy
	xscale = 1.0
	