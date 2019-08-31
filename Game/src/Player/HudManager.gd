extends Control

onready var inventory = $Inventory
onready var menu = $GameMenu
onready var open_audio = $OpenAudio
onready var close_audio = $CloseAudio

func _process(delta):
	if Input.is_action_just_pressed("inventory_toggle"):
		toggle(inventory)
	if Input.is_action_just_pressed("menu_toggle"):
		toggle(menu)
		
func toggle(item):
	item.visible = not item.visible
	if item.visible:
		open_audio.play()
	else:
		close_audio.play()
	get_tree().paused = not get_tree().paused

