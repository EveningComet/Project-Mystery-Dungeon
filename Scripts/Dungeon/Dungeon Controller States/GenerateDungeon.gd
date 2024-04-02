## Responsible for generating a dungeon.
class_name GenerateDungeon extends DCState

func enter(msgs: Dictionary = {}) -> void:
	print("GenerateDungeon :: Entered.")
	generate()

func generate() -> void:
	# First, generate the map
	await my_state_machine.walker_generator.generate()
	
	# Generate the player
	var player = my_state_machine.player_template.instantiate()
	my_state_machine.tile_map.add_child.call_deferred(player)
	player.get_node("Mover").set_tile_map( my_state_machine.tile_map )
	var tile_map: TileMap = my_state_machine.tile_map
	var pos: Vector2 = tile_map.map_to_local(Vector2i(0, 0))
	player.position = pos
	my_state_machine.camera_controller.set_target( player )
	
	# Generate a test ally
	var ally = my_state_machine.ally_template.instantiate()
	my_state_machine.tile_map.add_child.call_deferred(ally)
	pos = tile_map.map_to_local( Vector2i(0, 1) )
	var friendly = ally.get_node("Friendly")
	friendly.set_pathfinder( my_state_machine.pathfinder )
	friendly.set_player( player )
	ally.global_position = pos
	
	# Generate the pathfinder
	my_state_machine.pathfinder.initialize_pathfinding()
