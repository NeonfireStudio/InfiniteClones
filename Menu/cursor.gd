extends TextureRect

var clicked = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position() - Vector2(19, 12), delta*10.0)
	
	var tilt_amount = get_global_mouse_position()-global_position
	tilt_amount = tilt_amount.x
	
	tilt_amount = clampf(tilt_amount, -100, 100) / 6
	
	rotation_degrees = tilt_amount - 7
	
	if Input.is_action_pressed("left_mouse"):
		scale = lerp(scale, (Vector2.ONE*1.2)*0.9, delta*10.0)
		if !clicked: $ClickSound.play(0.1)
		clicked = true
	else:
		scale = lerp(scale, (Vector2.ONE)*1.5 * 0.9, delta*10.0)
		if clicked: clicked = false
