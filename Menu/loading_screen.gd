extends ColorRect

func _ready() -> void:
	fade_out()

func fade_in(target_scene):
	show()
	material.set("shader_parameter/progress", 0.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 0.5)
	
	if target_scene:
		await tween.finished
		$Cover.show()
		await get_tree().create_timer(0.7).timeout
		
		if target_scene != ".":
			get_tree().change_scene_to_file(target_scene)
		else:
			get_tree().reload_current_scene()

func next_level():
	#$AudioStreamPlayerGlobal.total_levelsD.play()
	show()
	material.set("shader_parameter/progress", 0.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 0.5)
	
	await tween.finished
	$Cover.show()
	randomize()
	
	$Label.modulate.a = 0
	
	$Label.text = Global.level_texts.pick_random() if Global.current_level <= Global.total_levels else "Thanks for playing!"
	if not Global.current_level <= Global.total_levels: $WinningSound.play()
	if Global.current_level <= Global.total_levels: $WinningSound2.play()
	
	$Label.scale = Vector2.ZERO
	
	var tween2 = create_tween()
	tween2.tween_property($Label, "modulate:a", 1, 0.25)
	tween2.tween_property($Label, "scale", Vector2(-1, 1), 0.25)
	
	await get_tree().create_timer(1.6).timeout
	tween2.kill()
	
	tween2 = create_tween()
	tween2.tween_property($Label, "modulate:a", 0, 0.25)
	tween2.tween_property($Label, "scale", Vector2(0, 0), 0.25)
	
	await tween2.finished
	
	if not Global.current_level <= Global.total_levels:
		get_tree().change_scene_to_file("res://Menu/menu.tscn")
		Global.last_id = -1
	
		Global.durations = {}
		Global.actions = {}
		Global.jumps = {}
		return
	
	if is_inside_tree(): get_tree().reload_current_scene()

func fade_out():
	show()
	$Cover.show()
	material.set("shader_parameter/progress", 1.0)
	
	await get_tree().create_timer(0.3).timeout
	$Cover.hide()
	
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0, 0.5)
	await tween.finished
	hide()
