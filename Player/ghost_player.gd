extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0-50
const JUMP_VELOCITY = -300*1.6#-400.0

var target_velocity = 0

var is_jumping = false

var jump_times = 1

var can_jump = true

var durations =  [2, 1, 3]
var actions = [1, 1, 1]

var counter = 0
var target_counter = 2

var last_record = 0
var current_action = -1

var id = 0
var target_scale = 1

var jumps = []
var jump_cooldown = 0

var last_jump = 0

var last_obj = null

func _ready() -> void:
	read_records()
	
	add_to_group("Enemy")
	if Global.current_level == 1 and id == 0: $Label.show()

func read_records():
	#if !durations: queue_free()
	#
	if last_record >= durations.size():
		last_record = durations.size()-1
	
	if last_record == -1 or durations == []: 
		queue_free()
		return
	
	target_counter = durations[last_record] 
	current_action = actions[last_record]
	
	last_record += 1
	counter = 0
	
	if last_jump < jumps.size() and jump_cooldown <= 0:
		jump_cooldown = jumps[last_jump]

func _physics_process(delta: float) -> void:
	if counter <= target_counter:
		counter += delta
	else:
		read_records()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor(): is_jumping = false
	
	if jumps and jump_cooldown > 0:
		jump_cooldown -= delta
		if jump_cooldown <= 0:
			print("OK")
			velocity.y = JUMP_VELOCITY
			last_jump += 1
			if last_jump < jumps.size():
				jump_cooldown = jumps[last_jump]
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_times != 0) and can_jump:
		#velocity.y = JUMP_VELOCITY
		is_jumping = true
		jump_times -= 1
		can_jump = false
		await get_tree().create_timer(0.2).timeout
		can_jump = true
		is_jumping = true
	
	if is_on_floor(): jump_times = 1
	
	if Input.is_action_just_released("jump"):
		velocity.y *= 0.4
	
	var direction = current_action
	if direction != 1 and position.x < 0: direction = 1
	
	if direction:
		target_velocity = direction * SPEED
		velocity.x = lerpf(velocity.x, target_velocity, delta*8.0)
	else:
		target_velocity = 0
		velocity.x = lerpf(velocity.x, target_velocity, delta*8.0)
	
	move_and_slide()
	play_animations(direction)
	
	#if direction: animated_sprite.scale.x = lerpf(animated_sprite.scale.x, -2 if direction <= 0 else 2, delta*12.5)
	if direction: target_scale = 1 if direction > 0 else -1
	animated_sprite.scale.x = lerpf(animated_sprite.scale.x, 2 * target_scale, delta*7.7)
	#position.y = clamp(position.y, -1000, 315)
	
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

func play_animations(dir):
	if is_on_floor():
		$AnimatedSprite2D.play(("Idle" if !dir else "Run") + str(Global.character_id))
	else:
		if velocity.y > 0: $AnimatedSprite2D.play("Fall" + str(Global.character_id))
	
	#if is_on_floor():
		#if target_velocity == 0:
			#animated_sprite.play("Idle" + str(Global.character_id))
		#else:
			#animated_sprite.play("Run" + str(Global.character_id))
	#else:
		#if is_jumping:
			#if jump_times == 1:
				#animated_sprite.play("Jump" + str(Global.character_id))
			#
			#await get_tree().create_timer(0.5).timeout
			#is_jumping = false
		
	#	if !is_jumping and !is_on_floor(): animated_sprite.play("Fall")

func end():
	$AnimationPlayer.play("disappear")
	await get_tree().create_timer(1.0).timeout
	queue_free()
