extends Spatial

onready var room_container = $Room
onready var player_container = $PlayerContainer
onready var temp = $Temp

var current_room = null

func _ready():
	GameSaver.connect("loaded", self, "on_game_loaded")
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
	
	player_container.get_child(0).global_transform.origin = spawn_translation
	current_room.connect_portal_signals(self)
	
func on_game_loaded():
	yield(get_tree(),"idle_frame")
	current_room = room_container.get_child(0)
	current_room.connect_portal_signals(self)
	for child in temp.get_children():
		child.queue_free()
