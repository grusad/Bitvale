extends Control

onready var inventory = $Inventory

func _process(delta):
	if Input.is_action_just_pressed("inventory_toggle"):
		toggle(inventory)
		
func toggle(item):
	item.visible = not item.visible
	get_tree().paused = not get_tree().paused

