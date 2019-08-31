extends Spatial

onready var area = $Pivot/Sprite3D/Area
onready var timer = $Timer
onready var particles = $Particles
onready var sprite = $Pivot/Sprite3D
onready var collision_shape = $Pivot/Sprite3D/Area/CollisionShape

var damage = 0
var knockback_force = 0
var piercing = 0
var projectile_speed = 0
var current_piercing = 0

var dir = Vector3()
var launched_from_translation = Vector3()
var executer = null

func _ready():
	set_process(false)
	area.connect("body_entered", self, "on_body_entered")
	timer.connect("timeout", self, "on_timer_timeout")
	collision_shape.disabled = true

func start(damage, knockback_force, piercing, projectile_speed, executer):
	self.damage = damage
	self.knockback_force = knockback_force
	self.piercing = piercing
	self.projectile_speed = projectile_speed
	self.dir = -global_transform.basis.z.normalized()
	self.launched_from_translation = get_global_transform().origin
	self.executer = executer
	particles.emitting = true
	collision_shape.disabled = false
	timer.start()
	set_process(true)
	
func _process(delta):
	global_translate(dir * projectile_speed * delta)
	
func on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hit(damage, knockback_force, launched_from_translation, executer)
		current_piercing += 1
		if current_piercing >= piercing:
			hide_and_disable()
	else:
		hide_and_disable()
		
func hide_and_disable():
	set_process(false)
	sprite.visible = false
	particles.emitting = false
	collision_shape.disabled = true

func on_timer_timeout():
	queue_free()