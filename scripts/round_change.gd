extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.round += 1
	$Round.text = "Round " + str(Global.round)
	Global.scale_speed = Global.scale_speed * 1.4
	Global.vertical_speed = Global.vertical_speed * 1.4
	# wait 2 seconds
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
