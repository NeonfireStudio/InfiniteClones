extends Control

var character_id = 1

func _on_next_pressed() -> void:
	character_id += 1
	if character_id > 4: character_id = 1
	
	update_character()

func update_character():
	$MainSprite.play("Idle" + str(character_id))


func _on_previous_pressed() -> void:
	character_id -= 1
	if character_id < 1: character_id = 4
	
	update_character()


func _on_select_button_pressed() -> void:
	Global.character_id = character_id
	
	$LoadingScreen.fade_in("res://World/world.tscn")

func _physics_process(delta: float) -> void:
	$ParallaxBackground.scroll_base_offset.x -= 90*0.8 * delta
	$ParallaxBackground.scroll_base_offset.y += 70*0.8 * delta
	$ParallaxBackground2.scroll_base_offset.x -= 35 * delta


func _on_play_button_pressed() -> void:
	Global.character_id = character_id
	$PlayButton/PressSound.play()
	
	$LoadingScreen.fade_in("res://World/world.tscn")


func _on_play_button_button_down() -> void:
	$PlayButton/PressSound.play()
