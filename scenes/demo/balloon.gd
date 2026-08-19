extends RigidBody2D

func _on_collide(body: Node) -> void:
	if body is Knife:
		pop()

func pop():
	$Sprite.visible = false
	$Particles.emitting = true
	$Collider.disabled = true
	gravity_scale *= -1
