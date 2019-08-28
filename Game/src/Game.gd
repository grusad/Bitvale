extends Spatial

onready var room_container = $Room
onready var player = $Player

var current_room = null

func _ready():
	
	current_room = load("res://src/rooms/Forest_01.tscn").instance()
	room_container.add_child(current_room)
	current_room.connect_portal_signals(self)

	
func switch_room(next_scene_path, portal_direction):

	current_room.queue_free()
	current_room = load(next_scene_path).instance()
	room_container.add_child(current_room)
	
	var dirs = {Globals.Direction.NORTH : Globals.Direction.SOUTH,
				Globals.Direction.SOUTH : Globals.Direction.NORTH,
				Globals.Direction.EAST : Globals.Direction.WEST,
				Globals.Direction.WEST : Globals.Direction.EAST
	}
	
	var spawn_translation = current_room.get_portal_position(dirs.get(portal_direction))
	
	player.global_transform.origin = spawn_translation
	current_room.connect_portal_signals(self)
	

