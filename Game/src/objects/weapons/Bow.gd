extends Spatial

export (float) var damage = 1.0
export (float) var knockback_force = 0.0
export (float) var piercing = 1.0
export (PackedScene) var projectile_scene = null
export (float) var projectile_speed = 1.0
export (float) var draw_speed = 1.0
export (float) var reload_speed = 1.0

onready var anim_player = $AnimationPlayer
onready var arrow_pivot = $Pivot/ArrowPivot
onready var sprite = $Pivot/Sprite3D
onready var crosshair = $Pivot/ArrowPivot/Aim/Crosshair

signal loaded

var loaded_projectile = null
var shake_amount = 0

func _ready():
	add_to_group("Weapon")
	anim_player.connect("animation_finished", self, "on_animation_finished")

func _process(delta):
	
	if shake_amount <= 0:
		set_process(false)
	
	var offset = Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount)
	sprite.offset = offset
	shake_amount -= delta
	
func add_projectile():
	loaded_projectile = projectile_scene.instance()
	arrow_pivot.add_child(loaded_projectile)

func shake_bow(amount):
	shake_amount = amount
	set_process(true)
	
func on_animation_finished(name):
	if name == "reload":
		emit_signal("loaded")
		
func get_stats():
	var stats = {
		"name" : self.name,
		"damage" : damage,
		"draw_speed" : draw_speed,
		"reload_speed" : reload_speed,
		"piercing" : piercing
	}
	return stats
	