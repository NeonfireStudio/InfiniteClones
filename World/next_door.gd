extends StaticBody2D

func _ready() -> void:
	$AnimationPlayer.speed_scale = 1.5

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimationPlayer.play("pressed")
		$ImpactSound.play()
		body.finish()
		await get_tree().create_timer(0.8).timeout
		get_tree().current_scene.next_level()
