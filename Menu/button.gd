extends TextureButton

var tween = null

func _ready() -> void:
	pivot_offset = size/2

func change_size_to(_size, duration):
	if tween == null:
		tween = create_tween()
	else:
		tween.kill()
		tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2.ONE * _size, duration)
