extends PanelContainer

onready var texture_button = $TextureButton

var item_path = ""

func _ready():
	texture_button.connect("pressed", self, "on_button_pressed")

func focus():
	texture_button.grab_focus()

	
func on_button_pressed():
	print(self.name, " pressed")