class_name FriendlyBrain extends Node

## The current character the player is controlling.
var player: Node2D

var pathfinder: Pathfinder
var path: Array[Vector2i] = []

func set_pathfinder(new_pathfinder: Pathfinder) -> void:
	pathfinder = new_pathfinder

func set_player(new_player: Node2D) -> void:
	player = new_player

func operate() -> void:
	if player != null:
		path = pathfinder.astar.get_id_path(
			pathfinder.tile_map.local_to_map( get_parent().global_position ), 
			pathfinder.tile_map.local_to_map( player.global_position )
		)
		
		path.pop_front()
		if path.size() == 1:
			get_parent().get_node("Pawn").finished_turn.emit(null)
			return
		
		if path.is_empty() == true:
			get_parent().get_node("Pawn").finished_turn.emit(null)
			return
		
		var p = pathfinder.tile_map.map_to_local(path[0])
		get_parent().get_node("Mover").move( p )
