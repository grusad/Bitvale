extends Control

onready var slots = $HBoxContainer/PanelContainer/CenterContainer/Slots

func _ready():
	self.connect("visibility_changed", self, "on_visibility_changed")

func on_visibility_changed():
	slots.get_child(0).focus()