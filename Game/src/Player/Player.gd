extends KinematicBody

onready var hand = $RotationPivot/Camera/Hand
onready var stats = $Stats
onready var camera = $RotationPivot/Camera
onready var anim_tree = $AnimationTree
onready var inventory = $HudManager/Inventory
onready var rotation_pivot = $RotationPivot

var vel = Vector3()
const ACCEL = 4.5
const DEACCEL= 16
const TURN_SPEED = 2.5

var dir = Vector3()

func _ready():
	add_to_group("Player")
	add_to_group("Save")
	inventory.set_player(self)
	hand.set_player(self)
	

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_animation()
			
func process_input(delta):

	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("strafe_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("strafe_right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("turn_left"):
		self.rotate_y(TURN_SPEED * delta)
	if Input.is_action_pressed("turn_right"):
		self.rotate_y(-TURN_SPEED * delta)
	if Input.is_action_pressed("attack") and not hand.is_drawing:
		hand.draw()
	elif not Input.is_action_pressed("attack") and hand.is_drawing:
		hand.release()
	

	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= stats.speed

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel.y = 0
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4)
	
func process_animation():
	anim_tree["parameters/idle_walk/blend_amount"] = vel.length() / stats.speed
	anim_tree["parameters/move_shoot/blend_amount"] = (hand.percent_drawn * 4) * 0.01
	
func hit(damage):
	stats.health -= damage
	camera.shake(0.2)
	if stats.health <= 0:
		die()
	
		
func die():
	return
	

func save_data():
	var save_data = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"translation" : Utils.vec3_to_dict(translation),
		"rotation" : Utils.vec3_to_dict(rotation_degrees),
		"scale" : Utils.vec3_to_dict(scale),
		"rotation_pivot" : Utils.vec3_to_dict(rotation_pivot.rotation_degrees),
		"stats" : stats.save_data()
	}
	return save_data

func load_data(data_dict):
	translation = Utils.dict_to_vec3(data_dict["translation"])
	rotation_degrees = Utils.dict_to_vec3(data_dict["rotation"])
	scale = Utils.dict_to_vec3(data_dict["scale"])
	rotation_pivot.rotation_degrees = Utils.dict_to_vec3(data_dict["rotation_pivot"])
	stats.load_data(data_dict["stats"])


func get_player_stats():
	return stats.get_stats()
	
func get_bow_stats():
	return $RotationPivot/Camera/Hand.get_wielding_weapon().get_stats()
	
func add_exp(experience):
	stats.gain_experience(experience)
	
func get_stats_node():
	return stats








