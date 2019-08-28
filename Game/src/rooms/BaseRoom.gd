 extends Spatial

onready var mobs_container = $Navigation/Mobs
onready var navigation = $Navigation
onready var portal_container = $Navigation/Portals

func _ready():
	for mob in mobs_container.get_children():
		mob.set_navigation(navigation)
		

func connect_portal_signals(game):
	for portal in portal_container.get_children():
		portal.connect("player_entered", game, "switch_room")
		
func get_portal_position(direction):
	for portal in portal_container.get_children():
		if portal.portal_direction == direction:
			return portal.get_spawn_position()
	
	return null