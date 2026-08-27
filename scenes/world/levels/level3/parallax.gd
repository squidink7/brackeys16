extends Sprite2D
# Custom Parallax script because Godot's Parallax2D just doesn't fucking work I guess.

## How much the node moves relative to the camera. 
## (0,0) = doesn't move. (1,1) = moves exactly with the camera. (0.5, 0.5) = moves at half speed.
@export var scroll_scale: float = 1.0

# Stores the node's starting global position
var _base_position: Vector2

func _ready():
	# Capture the initial global position as our baseline
	_base_position = global_position

func _process(_delta):
	# 1. Get the camera
	var cam: Camera2D = get_viewport().get_camera_2d()

	if not cam:
		return # No camera found, do nothing

	# 2. Calculate the camera's distance from the custom origin point
	var camera_distance_from_origin = cam.global_position - get_parent().global_position

	# 3. Apply the scale to get the parallax offset
	var parallax_offset = camera_distance_from_origin * scroll_scale / 10

	# 4. Update the node's position
	# We SUBTRACT the offset so that when the camera moves RIGHT, the background moves LEFT.
	global_position = _base_position - parallax_offset