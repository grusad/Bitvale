extends Area

onready var tween = $Tween

var target = null
var speed = 0
var accel = 0
var curr_speed = 0

func _ready():
	randomize()
	set_process(false)
	speed = rand_range(20, 40)
	accel = rand_range(20, 40)
	
	connect("body_entered", self, "on_body_entered")
	tween.connect("tween_completed", self, "on_tween_completed")
	
	var random_scale = rand_range(0.2, 1.0)
	scale = Vector3(random_scale, random_scale, random_scale)

func start(target):
	self.target = target
	var vec = Vector3(rand_range(0.5, 3.0),rand_range(0.5, 3.0),rand_range(0.5, 3.0))
	tween.interpolate_property(self, "translation", translation, translation + vec, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
func _process(delta):
	
	var target = self.target.global_transform.origin
	var start = global_transform.origin
	var dir = start.direction_to(target)
	
	curr_speed += accel * delta
	if curr_speed > speed:
		curr_speed = speed
		
	global_translate(dir * curr_speed * delta)
	
func on_body_entered(body):
	if body.is_in_group("Player"):
		body.add_exp(1)
		queue_free()
		
func on_tween_completed(object, key):
	set_process(true)
	
