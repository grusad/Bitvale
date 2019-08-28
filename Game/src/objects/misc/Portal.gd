extends Spatial

export (String, FILE, "*.tscn") var next_scene
export (Globals.Direction) var portal_direction

onready var area = $MeshInstance/Area

signal player_entered

func _ready():
	area.connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body):
	if body.is_in_group("Player"):
		if next_scene != null:
			emit_signal("player_entered", next_scene, portal_direction)
		else:
			print("no room given to the entered portal.")
			
func get_spawn_position():
	
	var offset = Vector3()
	
	match portal_direction:
		Globals.Direction.NORTH:
			offset = Vector3(0, 0, 2)
		Globals.Direction.SOUTH:
			offset = Vector3(0, 0, -2)
		Globals.Direction.EAST:
			offset = Vector3(-2, 0, 0)
		Globals.Direction.WEST:
			offset = Vector3(2, 0, 0)
			
	return global_transform.origin + offset
		
	