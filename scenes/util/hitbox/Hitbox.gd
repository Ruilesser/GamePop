extends Area2D


# Get the enemies detected by the hitbox
func get_enemies_detected(group: String) -> Array[Node]:
	var enemies: Array[Node] = []
	for body in self.get_overlapping_bodies():
		if body.is_in_group(group):
			enemies.append(body)
	return enemies