extends CharacterBody2D
class_name Player

var speed = 250

var air_velocity = 0
var target_scale = 1

var last_action = 0

var counter = 0 #need to reset both
var jump_counter = 0

var pos = -1

var is_walking = false

var last_y = 0

var last_obj = null
var finished = false

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	reload_counter()
	
	if Global.current_level == 1:
		position.x += 64

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction != 1 and position.x < 0: direction = 1
	
	velocity.x = lerpf(velocity.x, direction * speed, delta*8.0)
	if !is_on_floor() and !finished: velocity.y += 980 * delta
	if $CloneDetector.is_colliding(): velocity.y = 0
	
	if Input.is_action_pressed("jump") and (is_on_floor() or $CloneDetector.is_colliding()):
		velocity.y = -300*1.6
		$AnimatedSprite2D.play("Jump" + str(Global.character_id))
		Global.jumps[str(Global.last_id)].append(jump_counter)
		jump_counter = 0
		#$AnimationPlayer.play("jump")
	
	if !is_on_floor(): last_y = velocity.y
	if is_on_floor() and last_y > 50:
		$LandingSound.play()
		last_y = 0
	
	move_and_slide()
	
	if direction: target_scale = 1 if direction > 0 else -1
	$AnimatedSprite2D.scale.x = lerpf($AnimatedSprite2D.scale.x, 2 * target_scale, delta*7.7)
	
	if is_on_floor() or $CloneDetector.is_colliding():
		$AnimatedSprite2D.play(("Idle" if !direction else "Run") + str(Global.character_id))
	else:
		if velocity.y > 0: $AnimatedSprite2D.play("Fall" + str(Global.character_id))
	
	if Global.was_down:
		if last_action != direction:
			last_action = direction
			reload_counter()
		else:
			if Global.durations.size() < Global.last_id:
				pos = 0
				return
			
			if Global.durations[str(Global.last_id)]: 
				Global.durations[str(Global.last_id)][pos] = counter
				counter += delta
				jump_counter += delta
	
	if direction and is_on_floor() and !is_walking:
		is_walking = true 
		$WalkingSound.play()
	elif !direction and is_walking or !is_on_floor():
		$WalkingSound.stop()
		is_walking = false
	
	#if !is_on_floor():
		#air_velocity += 9.8 * delta
	#elif air_velocity > 0: air_velocity = 0
	
#	$OBJDetectorRight.target_position.x = 38.75*target_scale
	#$OBJDetectorLeft.target_position.x = 38.75*target_scale
	
	if $OBJDetectorLeft.is_colliding() and direction == -1:
		$OBJDetectorLeft.get_collider().dir = -1
		last_obj = $OBJDetectorLeft.get_collider()
	elif $OBJDetectorRight.is_colliding() and direction == 1:
		$OBJDetectorRight.get_collider().dir = 1
		last_obj = $OBJDetectorRight.get_collider()
	else:
		if last_obj: 
			last_obj.dir = 0
			last_obj = null

func reload_counter():
	counter = 0
	pos += 1
	#pos = 0
	Global.durations[str(Global.last_id)].append(counter)
	Global.actions[str(Global.last_id)].append(last_action)

func finish():
	pass
	#velocity.y = -150
	#move_and_slide()
	#
	#finished = true
	#
	#await get_tree().create_timer(0.5).timeout
	#velocity.y = 0
	#$AnimatedSprite2D2.show()
	#$AnimatedSprite2D.hide()
	#$AnimatedSprite2D2.play("default")
