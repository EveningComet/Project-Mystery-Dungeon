## Responsible for moving characters.
class_name Mover extends Node

## The pawn this movement component is a part of.
var pawn: Pawn

## The tile map used for the movement.
var tile_map: TileMap

var is_moving: bool = false

func set_pawn(new_pawn: Pawn) -> void:
	pawn     = new_pawn
	tile_map = pawn.tile_map

func move(direction: Vector2) -> void:
	if is_moving == true:
		return
	is_moving = true
	var tween: Tween = create_tween()
	tween.tween_property(get_parent(), "global_position", direction, 0.2).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	is_moving = false
	get_parent().get_node("Pawn").finished_turn.emit(null)
