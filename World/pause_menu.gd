extends Control

#SETPROJECTSETTINGSBGTOBLACK

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = !visible
		get_tree().paused = visible
