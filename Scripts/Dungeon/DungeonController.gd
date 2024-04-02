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
