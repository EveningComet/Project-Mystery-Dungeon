## Responsible for controlling a dungeon.
class_name DungeonController extends StateMachine

## The object responsible for generating our map.
@export var walker_generator: WalkerGenerator

## Used to help with generating characters.
@export var character_template: PackedScene

## The map storing the tiles for the dungeon.
@export var tile_map: TileMap

@export var pathfinder: Pathfinder

@export var player_dungeon_controller: PlayerDungeonController

@export var player_dungeon_hud: PlayerDungeonHUD

## The stored tiles of the walker so that the dungeon can do things with it.
var walked_tiles: PackedVector2Array = []

func set_walked_tiles(new_walked_tiles: PackedVector2Array) -> void:
	walked_tiles.append_array( new_walked_tiles )

func clear_walked_tiles() -> void:
	walked_tiles.clear()
