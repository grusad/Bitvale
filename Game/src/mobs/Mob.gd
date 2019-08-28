extends KinematicBody

export (float) var speed = 1.0

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite3D

var path = PoolVector3Array()
var nav = null
var vel = Vector3()
	
func _physics_process(delta):
	if path.size() > 0:
		move_along_path()
		set_animation("walk")
	else:
		set_animation("idle")
		

func move_along_path():
	
	if path.size() <= 0:
		return
	
	var target = path[0]
	if global_transform.origin.distance_to(target) < 0.1:
		path.remove(0)
	
	vel = (target - translation).normalized() * speed
	vel = move_and_slide(vel)

func find_path_to(target_translation):
	return nav.get_simple_path(global_transform.origin, target_translation)
	
	
func set_navigation(nav):
	self.nav = nav

func set_animation(animation_name):
	if (animation_player.current_animation == animation_name
		or not animation_player.has_animation(animation_name)):
		return
		
	else:
		animation_player.play(animation_name)
		
func clone_current_material():
	return sprite.material_override.duplicate(true)
		
	

