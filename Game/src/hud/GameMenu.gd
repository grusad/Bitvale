extends Control

onready var buttons = $PanelContainer/CenterContainer/Buttons
onready var save_button = $PanelContainer/CenterContainer/Buttons/Save
onready var load_button = $PanelContainer/CenterContainer/Buttons/Load

func _ready():
	self.connect("visibility_changed", self, "on_visibility_changed")
	save_button.connect("pressed", self, "on_save_pressed")
	load_button.connect("pressed", self, "on_load_pressed")

func on_visibility_changed():

	buttons.get_child(0).grab_focus()
	pass

func on_save_pressed():
	GameSaver.save_json(0)

func on_load_pressed():
	GameSaver.load_json(0)
	get_tree().paused = false
	