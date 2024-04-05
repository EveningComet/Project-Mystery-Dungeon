class_name FriendlyBrain extends AIBrain

## The current character the player is controlling.
var player: Pawn

func set_player(new_player: Pawn) -> void:
	player = new_player

func operate() -> void:
	if player == null:
		get_parent().get_node("Pawn").finished_turn.emit( null )
		return

	path = pathfinder.astar.get_id_path(
		pathfinder.tile_map.local_to_map( get_parent().global_position ), 
		pathfinder.tile_map.local_to_map( player.get_parent().global_position )
	).slice(1)
	
	if path.size() == 1:
		get_parent().get_node("Pawn").finished_turn.emit(null)
		return
	
	if path.is_empty() == true:
		get_parent().get_node("Pawn").finished_turn.emit(null)
		return
	
	var dir = (path[0] - pathfinder.tile_map.local_to_map(get_parent().global_position))
	get_parent().get_node("Pawn").update_raycast(dir)
	if get_parent().get_node("Pawn").ray.is_colliding() == true:
		get_parent().get_node("Pawn").finished_turn.emit(null)
		return
	
	# Checking to make sure the tile is valid
	#var tile_data = pathfinder.tile_map.get_cell_tile_data(0, path[0])
	#if tile_data != null and tile_data.get_custom_data("Type") == "Impassable":
		#get_parent().get_node("Pawn").finished_turn.emit(null)
		#return
	
	var p = pathfinder.tile_map.map_to_local(path[0])
	get_parent().get_node("Mover").move( p )
