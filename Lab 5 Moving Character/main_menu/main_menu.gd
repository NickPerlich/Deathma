class_name MainMenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_button as Button
@onready var controls_button = $MarginContainer/HBoxContainer/VBoxContainer/Controls_button as Button 
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_button as Button
#@onready var story_button = $MarginContainer/HBoxContainer/VBoxContainer/Story_button as Button
#@onready var start_level = preload("res://main.tscn") as PackedScene
#@onready var controls_scene = preload("res://main_menu/controls.tscn") as PackedScene

func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	controls_button.button_down.connect(on_controls_pressed)
	#story_button.button_down.connect(on_story_pressed)
	
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/controls.tscn")

#func on_story_pressed() -> void:
	#get_tree().change_scene_to_file("res://main_menu/story.tscn")
	
func on_exit_pressed() -> void:
	get_tree().quit()
