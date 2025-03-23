extends StaticBody2D

signal reached_player

@export var initial_scale = 0.9
@export var scale_speed = 10 # Adjust for scaling speed
@export var vertical_speed = 20 # Adjust for vertical movement speed
@export var max_scale = 1.8 # Maximum scale the wall will reach

var start_position: Vector2

func _ready():
	# Center horizontally, start above the view
	start_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y * 0.2)
	position = start_position
	scale = Vector2(initial_scale, initial_scale)

func _process(delta: float) -> void:
	# Approach player
	position.y += vertical_speed * delta
	scale += Vector2(scale_speed * delta * 0.01, scale_speed * delta * 0.01)
	
	#print("position y is:", position.y)
	#print("scale is:", scale)

	# Limit scaling
	#scale.x = min(scale.x, max_scale)
	#scale.y = min(scale.y, max_scale)

	# Check if reached player's Y position or off-screen
	if position.y > get_viewport_rect().size.y * 0.5: # Adjust value based on where your player is
		queue_free()
		emit_signal("reached_player")
