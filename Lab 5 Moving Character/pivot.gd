extends Node2D


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("left_click"):
		look_at(get_global_mouse_position())
