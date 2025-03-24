extends Node2D
signal LoopAreaEntered

@export var queue_at_start = false
@export var default_player_pos: Vector2

func _ready() -> void:
	if queue_at_start: queue_free()

func _on_loop_area_body_entered(body: Node2D) -> void:
	emit_signal("LoopAreaEntered", body)


func _on_button_body_entered(body: Node2D) -> void:
	if body is Player: $Platform/AnimationPlayer.play("move")


func _on_button_body_exited(body: Node2D) -> void:
	if body is Player: $Platform/AnimationPlayer.play_backwards("move")
