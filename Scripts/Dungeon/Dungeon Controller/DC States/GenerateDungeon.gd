## Responsible for generating a dungeon.
class_name GenerateDungeon extends DCState

@export var test_exit: PackedScene

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
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
	
	# TODO: Find a way that makes it so this delay is not needed.
	await get_tree().create_timer(1.0).timeout
	
	# Generate the pathfinder
	my_state_machine.pathfinder.initialize_pathfinding()
	
	spawn_player_party()
	spawn_enemies()
	spawn_exit()
	spawn_items()
	
	# Everything is done, start the player's turn
	my_state_machine.turn_controller.next_pawn()
	my_state_machine.change_to_state("DungeonRunning")

func spawn_player_party() -> void:
	# Generate the player
	var player = my_state_machine.player_template.instantiate()
	my_state_machine.tile_map.add_child(player)
	player.get_node("Pawn").set_tile_map( tile_map )
	player.get_node("Mover").set_pawn( player.get_node("Pawn") )
	var pos: Vector2 = tile_map.map_to_local( my_state_machine.walked_tiles[0] )
	player.position = pos
	player.get_node("Stats").initialize()
	EventBus.character_spawned_in_dungeon.emit( player.get_node("Pawn") )
	
	# Set the player's current pawn to be the one we just created
	my_state_machine.player_dungeon_controller.set_current_pawn( player.get_node("Pawn") )
	my_state_machine.player_dungeon_controller
	
	# Generate a test ally
	var ally = my_state_machine.ally_template.instantiate()
	tile_map.add_child(ally)
	pos = tile_map.map_to_local( my_state_machine.walked_tiles[1] )
	var friendly = ally.get_node("Friendly")
	friendly.set_pathfinder( my_state_machine.pathfinder )
	friendly.set_player( player )
	ally.global_position = pos
	ally.get_node("Mover").set_pawn( ally.get_node("Pawn") )
	ally.get_node("Stats").initialize()
	EventBus.character_spawned_in_dungeon.emit( ally.get_node("Pawn") )

func spawn_enemies() -> void:
	# Genereate a test enemy
	var enemy = my_state_machine.character_template.instantiate()
	enemy.get_node("Mover").set_pawn( enemy.get_node("Pawn") )
	tile_map.add_child(enemy)
	var pos = tile_map.map_to_local( my_state_machine.walked_tiles[10] )
	enemy.global_position = pos
	var enemy_brain: EnemyBrain = EnemyBrain.new()
	enemy_brain.name = "EnemyBrain"
	enemy.add_child( enemy_brain )
	enemy.get_node("Stats").initialize()
	EventBus.character_spawned_in_dungeon.emit( enemy.get_node("Pawn") )

func spawn_exit() -> void:
	# Generate the exit
	var exit = test_exit.instantiate()
	tile_map.add_child( exit )
	var walked_tiles = my_state_machine.walked_tiles
	# TODO: Randomize the tile for the exit.
	var final_pos    = walked_tiles[walked_tiles.size() - 1]
	exit.global_position = tile_map.map_to_local(final_pos)
	
	if OS.is_debug_build() == true:
		print("GenerateDungeon :: Exit spawned at coords: ", final_pos)

func spawn_items() -> void:
	pass
