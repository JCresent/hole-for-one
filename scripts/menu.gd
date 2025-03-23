extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset all of these for next round
	Global.score = 0
	Global.scale_speed = 10
	Global.vertical_speed = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_controls_pressed() -> void:
	print("Controls pressed")


func _on_quit_pressed() -> void:
	get_tree().quit()
