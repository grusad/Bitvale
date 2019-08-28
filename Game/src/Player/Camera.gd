extends Camera

var shake_amount = 0

func _ready():
	set_process(false)

func _process(delta):
	
	if shake_amount <= 0:
		set_process(false)
	
	v_offset = rand_range(-1.0, 1.0) * shake_amount
	h_offset = rand_range(-1.0, 1.0) * shake_amount
	shake_amount -= delta
	
func shake(amount):
	shake_amount = amount
	set_process(true)