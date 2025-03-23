extends StaticBody2D

@export var initial_scale = 0.9
@export var scale_speed = 90 # Adjust for scaling speed
@export var vertical_speed = 60 # Adjust for vertical movement speed
@export var max_scale = 1.0 # Maximum scale the wall will reach

var start_position: Vector2

func _ready():
	# Center horizontally, start above the view
	start_position = Vector2(get_viewport_rect().size.x / 2.5, get_viewport_rect().size.y * 0.2)
	position = start_position
	scale = Vector2(initial_scale/6, initial_scale)

func _process(delta: float) -> void:
	# Approach player
	position.y += vertical_speed * delta
	scale += Vector2(scale_speed * delta * 0.001, scale_speed * delta * 0.001)

	# Limit scaling
	scale.x = min(scale.x, max_scale)
	scale.y = min(scale.y, max_scale)

	# Check if reached player's Y position or off-screen
	if position.y > get_viewport_rect().size.y * 0.75: # Adjust value based on where your player is
		queue_free()
