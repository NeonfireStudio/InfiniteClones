extends StaticBody2D

var dir = 0
var moved = false

func _physics_process(delta: float) -> void:
	position.x += dir * 100 * delta
	
	if dir != 0 and !$Pushing.playing:
		$Pushing.play()
		moved = true
	elif dir == 0 and $Pushing.playing:
		$Pushing.stop()
		moved = true

func _process(delta: float) -> void:
	position.x = clamp(position.x, -210, 100)
