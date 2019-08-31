extends "res://src/mobs/Mob.gd"

export (float) var cooldown = 1.0
export (int) var hp = 10
export (int) var simple_attack_dmg = 1.0
export (int) var experience = 0

onready var vision_area = $Vision
onready var combat_range = $CombatRange
onready var shape = $CollisionShape
onready var hit_animation = $HitAnimationPlayer
onready var particles = $Particles
onready var die_timer = $Particles/Timer
onready var exp_globe = preload("res://src/objects/misc/ExpGlobe.tscn")

var target = null
var path_timer = null
var combat_length = 0
var cooldown_timer = null
var can_attack = true
var is_in_combat_range = false
var knocked_back = false
var knockback_vel = Vector3()
var has_unique_material = false
var is_dying = false

func _ready():
	
	vision_area.connect("body_entered", self, "on_body_entered")
	vision_area.connect("body_exited", self, "on_body_exited")
	
	combat_range.connect("body_entered", self, "on_body_enter_combat_range")
	combat_range.connect("body_exited", self, "on_body_exited_combat_range")
	
	path_timer = Timer.new()
	path_timer.wait_time = 1.0
	path_timer.connect("timeout", self, "on_path_timer_timeout")
	
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown
	cooldown_timer.connect("timeout", self, "on_cooldown_timer_timeout")
	cooldown_timer.one_shot = true
	
	add_child(path_timer)
	add_child(cooldown_timer)
	
	if combat_range.has_node("CollisionShape"):
		combat_length = combat_range.get_child(0).shape.radius
		
func _physics_process(delta):
	
	if knocked_back:
		knockback_vel = move_and_slide(knockback_vel)
		knockback_vel *= 0.8
		
		sprite.offset.x = -rand_range(-1.0, 1.0) * knockback_vel.length() * 0.2
		sprite.offset.y = -rand_range(-1.0, 1.0) * knockback_vel.length() * 0.2
		
		if knockback_vel.length() <= 0.01:
			knocked_back = false
			sprite.offset = Vector2()
	else:
		if is_dying:
			return
		._physics_process(delta)
		
func on_body_entered(body):
	if body.is_in_group("Player"):
		path_timer.start()
		target = body
		path = calculate_path()


func on_body_exited(body):
	if body.is_in_group("Player") and target != null:
		target = null
		path_timer.stop()
		path = PoolVector3Array()
	
func on_path_timer_timeout():
	path = calculate_path()
	
func calculate_path():
	var target = self.target.global_transform.origin
	var start = global_transform.origin
	var dir = start.direction_to(target)
	var length = start.distance_to(target) - combat_length
	var end = start + (dir * length)
	return find_path_to(end)
	
func on_body_enter_combat_range(body):

	is_in_combat_range = true
	
	if can_attack and body == target and not is_dying:
		simple_attack(target)
		cooldown_timer.start()
		can_attack = false
		
	
func on_body_exited_combat_range(body):
	if body == target:	
		is_in_combat_range = false
	
func on_cooldown_timer_timeout():
	if is_in_combat_range and not is_dying:
		simple_attack(target)
		cooldown_timer.start()
	can_attack = true
	
func simple_attack(target):
	print(name , " needs to override the simple attack function.")
	
func hit(damage, knockback_force, hit_from, executer):
	if not has_unique_material:
		sprite.material_override = clone_current_material()
		has_unique_material = true
		
	flash()
	hp -= damage
	apply_knockback(hit_from, knockback_force)
	if hp <= 0:
		die(executer)
		
func apply_knockback(from, force):
	var knockback_dir = -(from - get_global_transform().origin)
	knockback_dir.y = 0
	knockback_vel = (knockback_dir.normalized() * force) 
	knocked_back = true

func flash():
	hit_animation.play("flash")

		
func die(executer):
	particles.emitting = true
	die_timer.wait_time = particles.lifetime
	die_timer.connect("timeout", self, "on_enemy_dies")
	die_timer.start()
	sprite.visible = false
	shape.disabled = true
	is_dying = true
	#emitting exp
	for i in experience:
		var exp_instance = exp_globe.instance()
		Globals.temp_root.add_child(exp_instance)
		exp_instance.global_transform.origin = self.global_transform.origin
		exp_instance.start(executer)
		
func on_enemy_dies():
	queue_free()
