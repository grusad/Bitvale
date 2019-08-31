extends Node

var max_health = 25
var health = 25
var speed = 5
var defense = 0
var level = 1
var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)
var level_points = 0
var mana = 3
var max_mana = 3


func get_stats():
	var stats = {
		"max_health" : max_health,
		"speed" : speed,
		"defense" : defense,
		"level" : level,
		"experience" : experience,
		"experience_total" : experience_total,
		"experience_required" : experience_required,
		"level_points" : level_points,
		"mana" : mana,
		"max_mana" : max_mana
	}
	
	return stats
	
func _process(delta):
	if max_mana == 4:
		print (max_mana) 
	
func save_data():
	var dict = get_stats()
	dict["path"] = get_path()
	return dict
	
func load_data(data):
	max_health = data["max_health"]
	speed = data["speed"]
	defense = data["defense"]
	level = data["level"]
	experience = data["experience"]
	experience_total = data["experience_total"]
	level_points = data["level_points"]
	mana = data["mana"]
	max_mana = data["max_mana"]
	
	experience_required = get_required_experience(level + 1)
	

func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)
	

func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()

func level_up():
	level += 1
	level_points += 1
	experience_required = get_required_experience(level + 1)
	