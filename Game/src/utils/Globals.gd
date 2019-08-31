extends Node

enum Direction {NORTH, SOUTH, EAST, WEST}
var game_root = null
var temp_root = null

func _ready():
	game_root = get_tree().root.get_children()[3]
	temp_root = game_root.get_node("Temp")