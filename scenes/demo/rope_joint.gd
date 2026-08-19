extends DampedSpringJoint2D

@export var rope_length: float = 1.0

func _ready():
	# Connect the joint to your two bodies
	node_a = %MouseFollow.get_path()
	node_b = %Balloon.get_path()
	
	# The absolute maximum stretchable length of the spring
	length = rope_length 
	rest_length = rope_length
	
	# Tune these for how "strong" the tug is
	stiffness = 50.0 
	damping = 0.5

func _physics_process(_delta):
	if not is_instance_valid(%Balloon) or not is_instance_valid(%MouseFollow):
		return
		
	var distance = %Balloon.global_position.distance_to(%MouseFollow.global_position)
	
	# If the balloon is closer than the max rope length, the rope goes slack (0 force)
	if distance < rope_length:
		# Setting rest_length equal to distance means the spring is already at its target size, so it applies NO force.
		rest_length = distance
	else:
		# If it reaches the limit, the joint tries to pull it back to this length
		rest_length = rope_length
