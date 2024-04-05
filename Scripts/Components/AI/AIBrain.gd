class_name AIBrain extends Node

## The character this brain component manages.
var pawn: Pawn

var pathfinder: Pathfinder
var path: Array[Vector2i] = []

func set_pawn(new_pawn: Pawn) -> void:
	pawn = new_pawn

func set_pathfinder(new_pathfinder: Pathfinder) -> void:
	pathfinder = new_pathfinder
