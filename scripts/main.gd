extends Node2D

@onready var player = $Player/Sprite2D # Assuming your Player node is named "Player"
var current_wall = null # Track the current wall

const walls_array = ["res://assets/walls/wall_hoh.png", "res://assets/walls/wall_down.png", "res://assets/walls/wall_rdown_lup.png", "res://assets/walls/wall_rout_ldown.png",
					"res://assets/walls/wall_rup_lout.png", "res://assets/walls/wall_tpose.png"]
					
const hole_pose = {"res://assets/walls/wall_hoh.png":"res://assets/sprites/sm-hands-on-head.png", "res://assets/walls/wall_down.png":"res://assets/sprites/sm-down.png", 
					"res://assets/walls/wall_rdown_lup.png":"res://assets/sprites/sm-loneup-ronedown.png", "res://assets/walls/wall_rout_ldown.png":"res://assets/sprites/sm-ronet-lonedown.png",
					"res://assets/walls/wall_rup_lout.png":"res://assets/sprites/sm-rup-lout.png", "res://assets/walls/wall_tpose.png":"res://assets/sprites/sm-tpose.png"}
				
var wall_counter = 0

func _ready():
	$Score.text = "Score: " + str(Global.score)
	spawn_wall()
	
func round_change():
	get_tree().change_scene_to_file("res://scenes/round-change.tscn")

func spawn_wall():
	var wall_scene = load("res://scenes/wall.tscn")  # Replace with your Wall scene path
	current_wall = wall_scene.instantiate()
	add_child(current_wall)
	
	# Load random texture
	var choice = walls_array[randi() % walls_array.size()]
	current_wall.get_node("Sprite2D").texture = load(choice)
	
	# Connect the signal
	current_wall.reached_player.connect(validate_pose)
	
	# Set up the next wall if it's ready
	set_process(true)
	
	wall_counter += 1
	
func game_over():
	get_tree().change_scene_to_file("res://scenes/lose-screen.tscn")
	
func validate_pose():
	# Pose detection logic here: Replace with your actual pose checking
	var player_pose_matches = check_pose()
	
	if player_pose_matches:
		print("Pose matched! Next wall...")
		Global.score += 1
		update_score()
		
		if wall_counter == Global.round + 2:
			wall_counter = 0
			round_change()
			
		queue_free_current_wall()
		spawn_wall()
	else:
		print("Pose mismatch! Game Over!")
		game_over()

func queue_free_current_wall():
	# First, disconnect so there are not multiple calls
	current_wall.reached_player.disconnect(validate_pose)
	# remove the wall to spawn another one
	current_wall.queue_free()

func check_pose() -> bool:
	var hole = current_wall.get_node("Sprite2D").texture.resource_path
	var position = player.texture.resource_path
	
	if hole_pose[hole] == position:
		return true
	return false 
	
func _on_score_updated():
	$Score.text = "Score: " + str(Global.score)

func update_score():
	_on_score_updated()
	
	
