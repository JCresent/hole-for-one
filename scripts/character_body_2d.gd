extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Character poses:
var texture_down: Texture2D = preload("res://assets/sprites/sm-down.png") #1

var texture_left_out: Texture2D = preload("res://assets/sprites/sm-ronedown-lonet.png") #l2
var texture_left_up: Texture2D = preload("res://assets/sprites/sm-loneup-ronedown.png") #l3
var texture_left_up_rout: Texture2D = preload("res://assets/sprites/sm-lup-rout.png") #l4

var texture_right_out: Texture2D = preload("res://assets/sprites/sm-ronet-lonedown.png") #r2
var texture_right_up: Texture2D = preload("res://assets/sprites/sm-roneup-lonedown.png") #r3
var texture_right_up_lout: Texture2D = preload("res://assets/sprites/sm-rup-lout.png") #r4

var texture_tpose: Texture2D = preload("res://assets/sprites/sm-tpose.png")
var texture_v: Texture2D = preload("res://assets/sprites/sm-v-up.png")
var texture_hoh: Texture2D = preload("res://assets/sprites/sm-hands-on-head.png")

# Track current texture
var curr_texture: int = 0

# Enums for arms and direction
enum Arm {
	RIGHT,
	LEFT
}

enum Direction {
	UP,
	DOWN
}

# Define the state transitions as a dictionary
var state_transitions = {
	Arm.RIGHT: {
		Direction.UP: {
			# LEFT DOWN
			0: [1, "texture_right_out"],  # curr_texture 0 -> texture 1 (right out)
			1: [4, "texture_right_up"],  # curr_texture 1 -> texture 4 (right up)
			
			# LEFT OUT
			3: [2, "texture_tpose"],  # curr_texture 3 -> texture 2 (t pose)
			2: [10, "texture_right_up_lout"], # curr_texture 2 -> texture 10 (right up left out)
			
			# LEFT UP
			6: [11, "texture_left_up_rout"], # curr_texture 6 -> texture 11 (left up right out)
			11: [5, "texture_hoh"] # curr_texture 11 -> texture 5 (hoh)
		},
		Direction.DOWN: {
			# LEFT DOWN
			4: [1, "texture_right_out"],  # curr_texture 4 -> texture 1 (right out)
			1: [0, "texture_down"],  # curr_texture 1 -> texture 0 (down)
			
			# LEFT OUT
			2: [3, "texture_left_out"],  # curr_texture 2 -> texture 3 (left out)
			10: [2, "texture_tpose"], # curr_texture 10 -> texture 1 (right out)
			
			# LEFT UP
			5: [11, "texture_left_up_rout"], # curr_texture 5 -> texture 11 (left up right out)
			11: [6, "texture_left_up"] # curr_texture 11 -> texture 3 (left up)
		}
	},
	Arm.LEFT: {
		Direction.UP: {
			# RIGHT DOWN 
			0: [3, "texture_left_out"],  # curr_texture 0 -> texture 3 (left out)
			3: [6, "texture_left_up"],  # curr_texture 3 -> texture 6 (left up)
			
			
			# RIGHT OUT
			1: [2, "texture_tpose"],  # curr_texture 1 -> texture 2 (t pose)
			2: [11, "texture_left_up_rout"], # curr_texture 2 -> texture 11 (left up right out)
			
			# RIGHT UP
			4: [10, "texture_right_up_lout"], # curr_texture 4 -> texture 10 (right up left out)
			10: [5, "texture_hoh"] # curr_texture 10 -> texture 5 (hoh)
		},
		Direction.DOWN: {
			# RIGHT DOWN 
			6: [3, "texture_left_out"],  # curr_texture 6 -> texture 3 (left out)
			3: [0, "texture_down"],  # curr_texture 3 -> texture 0 (down)
			
			# RIGHT OUT 
			2: [1, "texture_right_out"],  # curr_texture 2 -> texture 1 (right out)
			11: [2, "texture_tpose"], # curr_texture 11 -> texture 2 (t pose)
			
			# RIGHT UP
			5: [10, "texture_right_up_lout"], # curr_texture 5 -> texture 10 (right up left out)
			10: [4, "texture_right_up"] # curr_texture 10 -> texture 4 (right up left down)
		}
	}
}


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle changing poses 
	if Input.is_action_just_pressed("right_arm_up"):
		change_pose(0, 0)
	if Input.is_action_just_pressed("right_arm_down"):
		change_pose(0, 1)
	if Input.is_action_just_pressed("left_arm_up"):	
		change_pose(1, 0)
	if Input.is_action_just_pressed("left_arm_down"):	
		change_pose(1, 1)
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# curr texture: 0 = both down, 1 = right out left down, 2 = both out (t pose), 3 = left out right down
				  # 4 = right on head and left down, 5 = hands on head, 6 = left on head and right down
				  # 7 = right up and left down, 8 = v (both up), 9 = left up and right down
				  # 10 = right up left out, 11 = left up right out
func change_pose(arm: int, dir: int):
	
	if state_transitions.has(arm) and state_transitions[arm].has(dir) and state_transitions[arm][dir].has(curr_texture):
		var next_state_data = state_transitions[arm][dir][curr_texture]
		var next_texture_index: int = next_state_data[0]
		var texture_name: String = next_state_data[1]
		
		# Use a match statement to set the texture
		match texture_name:
			"texture_down":
				$Sprite2D.texture = texture_down
			"texture_right_out":
				$Sprite2D.texture = texture_right_out
			"texture_left_out":
				$Sprite2D.texture = texture_left_out
			"texture_tpose":
				$Sprite2D.texture = texture_tpose
			"texture_right_up":
				$Sprite2D.texture = texture_right_up
			"texture_left_up":
				$Sprite2D.texture = texture_left_up
			"texture_hoh":
				$Sprite2D.texture = texture_hoh
			"texture_right_up_lout":
				$Sprite2D.texture = texture_right_up_lout
			"texture_left_up_rout":
				$Sprite2D.texture = texture_left_up_rout
			_:
				printerr("Invalid texture name: ", texture_name)
				return # Exit if the texture name is invalid
				
		curr_texture = next_texture_index
	else:
		printerr("Invalid state transition: arm=", arm, " dir=", dir, " curr_texture=", curr_texture)
