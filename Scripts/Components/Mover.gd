## Responsible for moving a character to a specified tile.
class_name Mover extends Node

## The tile map used for the movement.
var tile_map: TileMap

var is_moving: bool = false

var inputs: Dictionary = {
	"move_up": Vector2.UP,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT
}



func set_tile_map(new_map: TileMap) -> void:
	tile_map = new_map

func _unhandled_input(event: InputEvent) -> void:
	if is_moving == true:
		return
	
	for dir in inputs.keys():
		if event.is_action(dir):
			var curr_pos = tile_map.local_to_map( get_parent().global_position )
			var tile_data = tile_map.get_cell_tile_data(0, curr_pos + Vector2i(inputs[dir]))
			
			# If we can move to the position, go for it
			if tile_data != null and tile_data.get_custom_data("Type") != "Impassable":
				var target_pos: Vector2 = tile_map.map_to_local( curr_pos + Vector2i(inputs[dir]))
				var tween: Tween = create_tween()
				is_moving = true
				tween.tween_property(get_parent(), "global_position", target_pos, 0.2).set_trans(Tween.TRANS_LINEAR)
				await tween.finished
				is_moving = false
