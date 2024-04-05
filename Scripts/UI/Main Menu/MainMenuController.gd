## Manages the main menu.
class_name MainMenuController extends Node

@export_file("*tscn") var new_game_menu_scene: String
@export var new_game_button: Button
@export var quit_button: Button

func _ready() -> void:
	new_game_button.pressed.connect( on_new_game_button_pressed )
	quit_button.pressed.connect( on_quit_button_pressed )

func on_new_game_button_pressed() -> void:
	SceneController.switch_to_scene( new_game_menu_scene )

func on_quit_button_pressed() -> void:
	get_tree().quit()
