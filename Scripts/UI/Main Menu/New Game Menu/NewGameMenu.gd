## Controller for the new game menu.
class_name NewGameMenu extends Node

@export_file("*tscn") var dungeon_scene: String

## The place where the player can enter the name for their player character.
@export var name_entry: LineEdit

@export var male_button:   Button
@export var female_button: Button

@export var start_button: Button

func _ready() -> void:
	start_button.pressed.connect( on_start_button_pressed )
	
func on_start_button_pressed() -> void:
	SceneController.switch_to_scene( dungeon_scene )
	pass
