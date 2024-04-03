## Responsible for generating a dungeon.
class_name GenerateDungeon extends DCState

@export var test_exit: PackedScene

func enter(msgs: Dictionary = {}) -> void:
	print("GenerateDungeon :: Entered.")
	my_state_machine.walker_generator.walker_finished.connect( on_walker_finished )
	generate()

func exit() -> void:
	my_state_machine.walker_generator.walker_finished.disconnect( on_walker_finished )

func generate() -> void:
	# First, generate the map and wait for it to be finished
	my_state_machine.walker_generator.generate()

func on_walker_finished(location_history: PackedVector2Array) -> void:
	# Store the walked tiles
	var walked_tiles: PackedVector2Array = location_history
	my_state_machine.set_walked_tiles( walked_tiles )
	walked_tiles = my_state_machine.walked_tiles
	
	# TODO: Find a way that makes it so this delay is not needed.
	await get_tree().create_timer(1.0).timeout
	
	# Generate the pathfinder
	my_state_machine.pathfinder.initialize_pathfinding()
	
	# Generate the player
	var player = my_state_machine.player_template.instantiate()
	my_state_machine.tile_map.add_child(player)
	player.get_node("Mover").set_tile_map( my_state_machine.tile_map )
	var tile_map: TileMap = my_state_machine.tile_map
	var pos: Vector2 = tile_map.map_to_local( my_state_machine.walked_tiles[0] )
	player.position = pos
	my_state_machine.camera_controller.set_target( player )
	my_state_machine.turn_controller.add_pawn( player.get_node("Pawn") )
	
	var astar: AStarGrid2D = my_state_machine.pathfinder.astar
	var start = my_state_machine.tile_map.local_to_map( my_state_machine.walked_tiles[1] )
	var end   = my_state_machine.tile_map.local_to_map( my_state_machine.walked_tiles[0] )
	print( "GenerateDungeon :: ", astar.get_id_path(start, end) )
	
	# Generate a test ally
	var ally = my_state_machine.ally_template.instantiate()
	my_state_machine.tile_map.add_child(ally)
	pos = tile_map.map_to_local( my_state_machine.walked_tiles[1] )
	var friendly = ally.get_node("Friendly")
	friendly.set_pathfinder( my_state_machine.pathfinder )
	friendly.set_player( player )
	ally.global_position = pos
	my_state_machine.turn_controller.add_pawn( ally.get_node("Pawn") )
	
	# Generate the exit
	var exit = test_exit.instantiate()
	my_state_machine.tile_map.add_child( exit )
	var final_pos = walked_tiles[walked_tiles.size() - 1]
	exit.position = my_state_machine.tile_map.map_to_local(final_pos)
	print("GenerateDungeon :: Exit spawned at coords: ", final_pos)
	
	# Everything is done, start the player's turn
	my_state_machine.turn_controller.next_pawn()
