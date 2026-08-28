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

	if energy <= 0:
		if get_brain() is PlayerBrain:
			get_brain().end_game()
			#TODO: SubGLOWING WINDOW nedd to be tied to hp system
		return
	
	update_light()

func update_light():
	$Visuals/SubGlowingWindow.modulate.v = energy / max_energy
	$PointLight2D.modulate.v = energy / max_energy

func add_energy(amount: int) -> void:
	energy = min(energy + amount, max_energy)

	update_light()

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
