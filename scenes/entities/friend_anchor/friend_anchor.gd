extends Marker2D

func on_enter(body: Node2D):
	for c in get_children():
		if c is Entity && c.get_brain() is FriendBrain:
			c.get_brain().on_seen(body)