## Manages the player in the dungeon controller.
class_name PlayerDungeonController extends Node

@export var camera_controller: CameraController

## The character the player is currently controlling.
var curr_pawn: Pawn

var party: Array = []

func switch_controlled_character() -> void:
	pass
