## A character in the game world. This is the "heart" of a character, that
## all components a character will need shall interact with.
class_name Pawn extends Node

signal finished_turn(action: Action)

@export var ray: RayCast2D

var tile_map: TileMap
var my_turn: bool = false

var ground_interactable_standing_over: InteractableOnGround = null

func set_tile_map(new_tm: TileMap) -> void:
	tile_map = new_tm

func set_interactable_standing_over(ground_interactable: InteractableOnGround) -> void:
	ground_interactable_standing_over = ground_interactable

func toggle_active() -> void:
	my_turn = !my_turn

func update_raycast(direction: Vector2) -> void:
	ray.target_position = direction * tile_map.tile_set.tile_size.x
	ray.force_raycast_update()
