extends Node2D

@export var default_player_pos: Vector2

var counted_time = 0

var time_to_follow = false
var just_timed_to_follow = false

var follow_obj = null

func _ready() -> void:
	randomize()
	
	var current_level = load("res://World/level_" + str(Global.current_level) + ".tscn").instantiate()
	add_child(current_level)
	current_level.LoopAreaEntered.connect(_on_loop_area_body_entered)
	default_player_pos = current_level.default_player_pos
	
	$Player.position = default_player_pos
	Global.last_id += 1
	var a = {
			str(Global.last_id): []
	}
	var b = {
			str(Global.last_id): []
	}
	var c = {
			str(Global.last_id): []
	}
	
	Global.durations.merge(a)
	Global.actions.merge(b)
	Global.jumps.merge(c)
	
	$ParallaxBackground/ParallaxLayer/TextureRect.texture = [preload("res://Assets/Sprites/Pink.png"), preload("res://Assets/Sprites/Purple.png"), preload("res://Assets/Sprites/Green.png"), preload("res://Assets/Sprites/Blue.png"), preload("res://Assets/Sprites/Brown.png"), preload("res://Assets/Sprites/Gray.png")].pick_random()
	
	await get_tree().create_timer(1.0).timeout
	if Global.current_level == 1:
		$HUD/TitleLabel.text = "[center][u]How To Play"
	else:
		$HUD/TitleLabel.text = "[center][u]Level " + str(Global.current_level-1)
	
	$HUD/TitleLabel/AnimationPlayer.play("show_up")
	
	if Global.current_level == 1:
		$StaticBody2D/CollisionShape2D.disabled = false
		await $HUD/TitleLabel/AnimationPlayer.animation_finished
		$HUD/Label/AnimationPlayer.play("tutorial")
		$GreenArea/AnimationPlayer.play("fade_in")
		#$GreenArea/Timer.start()

func _physics_process(delta: float) -> void:
	$ParallaxBackground.scroll_base_offset.x -= 90*0.8 * delta
	$ParallaxBackground.scroll_base_offset.y += 70*0.8 * delta
	$ParallaxBackground2.scroll_base_offset.x -= 35 * delta
	
	if Input.is_action_just_pressed("reload"):
		_on_restart_pressed()
	
	if Global.current_level == 1 and !$GreenArea/GreenLabel.visible:
		if ($GreenArea/PlayerDetector.is_colliding() or counted_time > 0) and $GreenArea/Timer.is_stopped() and $GreenArea.modulate.a > 0.5:
			$GreenArea/Timer.start()
		elif !$GreenArea/PlayerDetector.is_colliding() and !$GreenArea/Timer.is_stopped() and counted_time == 0:
			$GreenArea/Timer.stop()
	
	if follow_obj:
		if follow_obj.get_node("Label").global_position.x > 20:
			$Label2.position = lerp($Label2.position, follow_obj.get_node("Label").global_position, delta*10.0)

func _on_loop_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.current_level == 1 and $GreenArea.modulate.a > 0.5:
			$GreenArea/AnimationPlayer.play("fade_out")
			$Label/AnimationPlayer.play("fade_out")
			$Label2/AnimationPlayer.play("appear")
			time_to_follow = true
			just_timed_to_follow = true
		
		body.position = default_player_pos
		body.pos = -1
		body.counter = 0
		body.jump_counter = 0
		
		#body.reload_counter()
		
		Global.last_id += 1
		var a = {
			str(Global.last_id): []
		}
		var b = {
			str(Global.last_id): []
		}
		var c = {
			str(Global.last_id): []
		}
		
		Global.durations.merge(a)   
		Global.actions.merge(b)
		Global.jumps.merge(c)
		
		var ghosts = get_tree().get_nodes_in_group("Enemy")
		for g in ghosts:
			g.end()
		
		for i in range(Global.last_id):
			var ghost_player = preload("res://Player/ghost_player.tscn").instantiate()
			ghost_player.position = default_player_pos
			ghost_player.durations = Global.durations[str(i)]
			ghost_player.actions = Global.actions[str(i)]
			ghost_player.jumps = Global.jumps[str(i)]
			ghost_player.id = i
			
			add_child(ghost_player)
			
			if just_timed_to_follow:
				follow_obj = ghost_player
				just_timed_to_follow = false

func next_level():
	Global.last_id = -1
	
	var a = {
			str(Global.last_id): []
	}
	var b = {
			str(Global.last_id): []
	}
	var c = {
			str(Global.last_id): []
	}
	
	$HUD/LoadingScreen.next_level()
	Global.current_level += 1
	Global.durations = a
	Global.actions = b
	Global.jumps = c

func _on_restart_pressed() -> void:
	$HUD/LoadingScreen.fade_in(".")
	
	Global.last_id = -1
	
	var a = {
			str(Global.last_id): []
	}
	var b = {
			str(Global.last_id): []
	}
	
	Global.durations = a
	Global.actions = b


func _on_timer_timeout() -> void:
	if $GreenArea/PlayerDetector.is_colliding():
		counted_time += 1
	else:
		counted_time -= 1
	
	counted_time = clamp(counted_time, 0, 5)
	$GreenArea/Label.text = str(counted_time)
	$GreenArea/Label.visible = true if counted_time > 0 else false
	if counted_time >= 5:
		$GreenArea/GreenLabel.show()
		$GreenArea/Label.hide()
		$GreenArea/Timer.stop()
		$Label/AnimationPlayer.play("init")
		$HUD/Label/AnimationPlayer.play("complete")
		$StaticBody2D/CollisionShape2D.disabled = true
		$AudioStreamPlayer2D.play()


func _on_restart_button_down() -> void:
	$HUD/Restart/ClickSound.play()
