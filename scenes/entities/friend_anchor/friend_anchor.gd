extends Marker2D
class_name FriendAnchor

func on_enter(body: Node2D):
	for c in get_children():
		if c is Entity && c.get_brain() is FriendBrain:
			c.get_brain().on_seen(body)