## A character in the game world.
class_name Pawn extends Node

signal finished_turn(action: Action)

var my_turn: bool = false

func toggle_active() -> void:
	my_turn = !my_turn
