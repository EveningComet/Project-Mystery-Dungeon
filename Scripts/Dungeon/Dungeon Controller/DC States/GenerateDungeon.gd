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
	spawn_potential_party_members()
	spawn_enemies()
	spawn_exit()
	spawn_items()
	
	# Set the current pawn for the player
	# TODO: Set this properly for floor transitions.
	my_state_machine.player_dungeon_controller.set_current_pawn(
		PlayerPartyController.party_members[0]
	)
	
	# The player can now start playing
	EventBus.dungeon_finished_generating.emit()
	
	my_state_machine.change_to_state("DungeonRunning")

func spawn_player_party() -> void:
	# Setup the player characters
	var i: int = 0
	for party_member in PlayerPartyController.get_children():
		party_member.reparent( tile_map )
		var stats: PlayerCharacterStats = party_member.get_node("Stats")
		my_state_machine.player_dungeon_hud.create_display_for_pm( stats )
		var pawn: Pawn = party_member.get_node("Pawn")
		pawn.set_tile_map( tile_map )
		var mover: Mover = party_member.get_node("Mover")
		mover.set_pawn( pawn )
		if party_member.has_node("FriendlyBrain") == true:
			party_member.get_node("FriendlyBrain").set_pathfinder( my_state_machine.pathfinder )
			party_member.get_node("FriendlyBrain").set_player( PlayerPartyController.party_members[0] )
		
		# Attempt to place the party near one another
		var pos: Vector2 = tile_map.map_to_local( my_state_machine.walked_tiles[i] )
		party_member.global_position = pos
		
		# Notify anything that needs to know about the spawning
		EventBus.character_spawned_in_dungeon.emit( pawn )
		i += 1

func spawn_potential_party_members() -> void:
	# TODO: Random chance for generation.
	# Generating a test ally that can join the player
	var ally = my_state_machine.character_template.instantiate()
	ally.get_node("FactionOwner").set_faction_type( FactionOwner.FactionType.Neutral )
	tile_map.add_child(ally)
	var pos = tile_map.map_to_local( my_state_machine.walked_tiles[2] )
	ally.global_position = pos
	var friendly: FriendlyBrain = FriendlyBrain.new()
	friendly.name = "FriendlyBrain"
	ally.add_child(friendly)
	var pawn: Pawn = ally.get_node("Pawn")
	pawn.set_tile_map( tile_map )
	friendly.set_pathfinder( my_state_machine.pathfinder )
	ally.get_node("Mover").set_pawn( pawn )
	var stats: PlayerCharacterStats = PlayerCharacterStats.new()
	stats.name = "Stats"
	stats.initialize()
	ally.add_child( stats )
	var texture = preload("res://Imported Assets/32rogues-spriteset/rogues.png")
	var sprite: Sprite2D = ally.get_node("Character Sprite")
	sprite.set_texture( texture )
	sprite.hframes = 8
	sprite.vframes = 8
	sprite.frame   = 18
	EventBus.character_spawned_in_dungeon.emit( pawn )

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
	var enemy_stats: EnemyStats = EnemyStats.new()
	enemy_stats.name = "Stats"
	enemy_stats.initialize()
	enemy.add_child(enemy_stats)
	EventBus.character_spawned_in_dungeon.emit( enemy.get_node("Pawn") )

func spawn_exit() -> void:
	# Generate the dungeon exit
	var dungeon_exit = test_exit.instantiate()
	tile_map.add_child( dungeon_exit )
	var walked_tiles = my_state_machine.walked_tiles
	# TODO: Randomize the tile for the exit.
	var final_pos    = walked_tiles[walked_tiles.size() - 1]
	dungeon_exit.global_position = tile_map.map_to_local(final_pos)
	
	if OS.is_debug_build() == true:
		print("GenerateDungeon :: Exit spawned at coords: ", final_pos)

func spawn_items() -> void:
	pass
