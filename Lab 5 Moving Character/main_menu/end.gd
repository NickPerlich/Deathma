class_name End
extends Control


#@onready var return_menu = preload("res://main_menu/main_menu.tscn") as PackedScene
@onready var back_button = $TextureRect/MarginContainer/HBoxContainer/VBoxContainer/Back_Button as Button


func _ready():
	back_button.button_down.connect(on_back_pressed)
	
func on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

