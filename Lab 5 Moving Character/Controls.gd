class_name Controls
extends Control


@onready var back_button = $TextureRect/MarginContainer/HBoxContainer/VBoxContainer/Back_Button as Button
#@onready var main_menu = preload("res://main_menu/main_menu.tscn") as PackedScene

func _ready():
	back_button.button_down.connect(on_back_pressed)
	
	
func on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

