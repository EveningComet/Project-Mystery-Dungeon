## Manages the player in the dungeon controller.
class_name PlayerDungeonController extends Node

@export var camera_controller: CameraController
@export var tile_map: TileMap

## The character the player is currently controlling.
var curr_pawn: Pawn

## The party members the player is controlling in the dungeon
var party: Array[Pawn] = []

var inputs: Dictionary = {
	"move_up": Vector2.UP,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT
}

func _unhandled_input(event) -> void:
	if curr_pawn == null or curr_pawn.my_turn == false:
		return
	
	# Handling of movement
	for dir in inputs.keys():
		if event.is_action(dir):
			var curr_pos = tile_map.local_to_map( curr_pawn.get_parent().global_position )
			var tile_data = tile_map.get_cell_tile_data(0, curr_pos + Vector2i(inputs[dir]))
			
			curr_pawn.update_raycast( inputs[dir] )
			if curr_pawn.ray.is_colliding() == true:
				var my_faction_owner: FactionOwner = curr_pawn.get_parent().get_node("FactionOwner")
				if curr_pawn.ray.get_collider().has_node("FactionOwner"):
					var t = curr_pawn.ray.get_collider().get_node("FactionOwner")
					if my_faction_owner.faction_type == FactionOwner.FactionType.PartyMember and t.faction_type == FactionOwner.FactionType.Enemy:
						curr_pawn.ray.get_collider().get_node("Stats").take_damage( 50 )
						curr_pawn.finished_turn.emit(null)
						return
			
			# If we can move to the position, go for it
			if tile_data != null and tile_data.get_custom_data("Type") != "Impassable":
				var target_pos: Vector2 = tile_map.map_to_local( curr_pos + Vector2i(inputs[dir]))
				curr_pawn.get_parent().get_node("Mover").move(target_pos)
	
## Set the current pawn the player will be controlling and disable that pawn's
## AI brain.
func set_current_pawn(new_curr_pawn: Pawn) -> void:
	curr_pawn = new_curr_pawn
	camera_controller.set_target( curr_pawn.get_parent() )

func switch_controlled_character() -> void:
	pass
