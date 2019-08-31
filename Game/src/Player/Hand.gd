extends Spatial

var is_drawing = false
var projectile_instance = null
var is_loaded = false
var draw_timer = null
var current_weopen = null
var percent_drawn = 0
var player = null

func _ready():
	draw_timer = Timer.new()
	draw_timer.connect("timeout", self, "on_draw_timer_timerout")
	draw_timer.one_shot = true
	add_child(draw_timer)
	equip(load("res://src/objects/weapons/WoodenBow.tscn").instance())
	
func _process(delta):
	if is_drawing:
		percent_drawn = (1 - (draw_timer.time_left / draw_timer.wait_time)) * 100
	else:
		percent_drawn = 0
	
	if current_weopen != null:	
		current_weopen.shake_bow(percent_drawn * 0.0025)

func draw():
	
	if current_weopen == null or not is_loaded:
		return
	
	draw_timer.start()
	is_drawing = true
	current_weopen.anim_player.play("draw")
	current_weopen.anim_player.playback_speed = 1 / current_weopen.draw_speed
	
	
func release():
	var percent_to_power = percent_drawn * 0.01
	var projectile_instance = current_weopen.loaded_projectile
	projectile_instance.start(current_weopen.damage * percent_to_power, current_weopen.knockback_force * percent_to_power, current_weopen.piercing, current_weopen.projectile_speed * percent_to_power, player)
	current_weopen.arrow_pivot.remove_child(projectile_instance)
	Globals.temp_root.add_child(projectile_instance)
	projectile_instance.global_transform = current_weopen.arrow_pivot.global_transform
	projectile_instance.global_transform.basis.z.y = 0
	is_loaded = false
	is_drawing = false
	current_weopen.anim_player.play("idle")
	current_weopen.crosshair.visible = false
	draw_timer.stop()
	load_bow()
	
func load_bow():
	if is_loaded:
		return
	current_weopen.anim_player.play("reload")
	current_weopen.anim_player.playback_speed = 1 / current_weopen.reload_speed
	
		
func get_wielding_weapon():
	return current_weopen

func on_draw_timer_timerout():
	print("full drawn bow.")
	
func equip(bow):
	if current_weopen != null:
		return
		
	add_child(bow)
	current_weopen = bow
	current_weopen.connect("loaded", self, "on_bow_loaded")
	draw_timer.wait_time = current_weopen.draw_speed
	load_bow()
	
func on_bow_loaded():
	is_loaded = true
	current_weopen.anim_player.play("idle")
	current_weopen.crosshair.visible = true
	
func set_player(player):
	self.player = player