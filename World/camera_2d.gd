extends Camera2D

@export var shake_intensity: float = 10.0  # Max position shake offset
@export var shake_rotation_intensity: float = 5.0  # Max rotation shake (degrees)
@export var shake_duration: float = 0.5  # Duration of shake
@export var frequency: float = 30.0  # Speed of shake movements
@export var damping: float = 3.0  # How fast the shake fades

@export var noise: FastNoiseLite

var _shake_time: float = 0.0
var _time_x: float = 0.0
var _time_y: float = 100.0  # Offset for different axis movement
var _time_rot: float = 200.0  # Offset for rotation shake

func _physics_process(delta: float) -> void:
	var extra_pos = (Vector2(800, 600) - get_viewport().get_mouse_position()) - Vector2(800, 600)/2
	extra_pos /= 10
	
	extra_pos.x = clampf(extra_pos.x, -25, 0)
	
	self.position = lerp(self.position, -extra_pos, delta*10.0)

func _process(delta):
	return
	
	if _shake_time > 0:
		_shake_time -= delta
		var decay = exp(-damping * delta)  # Smooth decay

		# Use Perlin noise for smooth motion
		_time_x += delta * frequency
		_time_y += delta * frequency
		_time_rot += delta * frequency * 0.5

		var shake_offset = Vector2(
			(noise.get_noise_1d(_time_x) - 0.5) * shake_intensity * decay,
			(noise.get_noise_1d(_time_y) - 0.5) * shake_intensity * decay
		)

		var shake_rotation = (noise.get_noise_1d(_time_rot) - 0.5) * shake_rotation_intensity * decay

		offset = shake_offset
		rotation_degrees = shake_rotation
	else:
		offset = Vector2.ZERO
		rotation_degrees = 0.0

func shake(intensity: float = 10.0, rot_intensity: float = 5.0, duration: float = 0.5):
	shake_intensity = intensity
	shake_rotation_intensity = rot_intensity
	shake_duration = duration
	_shake_time = duration
	_time_x = randf() * 100  # Randomize start for unique shakes
	_time_y = randf() * 100
	_time_rot = randf() * 100
