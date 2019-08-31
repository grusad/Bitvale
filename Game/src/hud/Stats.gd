extends Control

onready var player_stats_container = $VBoxContainer/HBoxContainer/PlayerStats/Stats/HBoxContainer/PlayerStatsContainer
onready var bow_stats_container = $VBoxContainer/HBoxContainer/BowStats/Stats/BowStatsContainer
onready var buttons = $VBoxContainer/HBoxContainer/PlayerStats/Buttons/GridContainer

var player = null

func _ready():
	self.connect("visibility_changed", self, "on_visibility_changed")
	
	buttons.get_node("Speed").connect("pressed", self, "on_speed_upgrade_pressed")
	buttons.get_node("Defense").connect("pressed", self, "on_defense_upgrade_pressed")
	buttons.get_node("Mana").connect("pressed", self, "on_mana_upgrade_pressed")
	buttons.get_node("Health").connect("pressed", self, "on_health_upgrade_pressed")
	
func set_player(player):
	self.player = player

func on_visibility_changed():
	
	if self.visible:
		buttons.get_child(0).grab_focus()
		update_labels()
	
func set_disable_all_buttons(boolean):
	for child in buttons.get_children():
		child.disabled = boolean
	
func update_labels():
	
	var player_stats = player.get_player_stats()
	
	if player_stats["level_points"] > 0:
		set_disable_all_buttons(false)
	else:
		set_disable_all_buttons(true)
	
	player_stats_container.get_node("Level").text = str(player_stats["level"])
	player_stats_container.get_node("Speed").text = str(player_stats["speed"])
	player_stats_container.get_node("Health").text = str(player_stats["max_health"])
	player_stats_container.get_node("Defense").text = str(player_stats["defense"])
	player_stats_container.get_node("Exp").text = str(player_stats["experience"]) + "/" + str(player_stats["experience_required"] )
	player_stats_container.get_node("Mana").text = str(player_stats["max_mana"])
		
	var bow_stats = player.get_bow_stats()
	bow_stats_container.get_node("Name").text = str(bow_stats["name"])
	bow_stats_container.get_node("Damage").text = str(bow_stats["damage"])
	bow_stats_container.get_node("Speed").text = str(bow_stats["draw_speed"])
	bow_stats_container.get_node("Reload").text = str(bow_stats["reload_speed"])
	bow_stats_container.get_node("Piercing").text = str(bow_stats["piercing"])		
	
func on_speed_upgrade_pressed():
	player.get_stats_node().speed += 1
	player.get_stats_node().level_points -= 1
	update_labels()
	
func on_defense_upgrade_pressed():
	player.get_stats_node().defense += 1
	player.get_stats_node().level_points -= 1
	update_labels()
	
func on_mana_upgrade_pressed():
	player.get_stats_node().max_mana += 2
	player.get_stats_node().level_points -= 1
	update_labels()
	
func on_health_upgrade_pressed():
	player.get_stats_node().max_health += 5
	player.get_stats_node().level_points -= 1
	update_labels()