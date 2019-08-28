extends RayCast

onready var crosshair = $Crosshair

func _process(delta):
	
	if self.is_colliding():
		var collider = self.get_collider()
		crosshair.global_transform.origin = get_collision_point()
		crosshair.look_at(crosshair.global_transform.origin - get_collision_normal(), Vector3.UP)
	else:
		crosshair.global_transform.origin += cast_to