## Responsible for controlling a dungeon.
class_name DungeonController extends StateMachine

## The object responsible for generating our map.
@export var walker_generator: WalkerGenerator

@export var player_template: PackedScene

@export var ally_template: PackedScene

## The map storing the tiles for the dungeon.
@export var tile_map: TileMap

@export var pathfinder: Pathfinder

@export var camera_controller: CameraController

@export var turn_controller: TurnController

## The stored tiles of the walker so that the dungeon can do things with it.
var walked_tiles: PackedVector2Array = []

func set_walked_tiles(new_walked_tiles: PackedVector2Array) -> void:
	walked_tiles.append_array( new_walked_tiles )

func clear_walked_tiles() -> void:
	walked_tiles.clear()
