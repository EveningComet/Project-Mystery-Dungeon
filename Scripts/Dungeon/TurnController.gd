## Keeps track of what character should be allowed to do anything at a given time.
class_name TurnController extends Node

## The current characters in the game world.
var current_entities: Array[Pawn] = []

## The order of the characters.
var turn_queue: Array[Pawn] = []

## The current character's turn.
var curr_pawn: Pawn = null

func _ready() -> void:
	EventBus.dungeon_finished_generating.connect( on_dungeon_finished_generating )
	EventBus.hp_depleted.connect( on_pawn_hp_depleted )
	EventBus.advancing_to_next_floor.connect( on_advancing_to_next_floor )
	EventBus.character_spawned_in_dungeon.connect( on_pawn_spawned )
	EventBus.player_swapped_controlled_character.connect( on_player_swapped_controlled_character )

func on_pawn_spawned(new_pawn: Pawn) -> void:
	add_pawn( new_pawn )

func next_pawn() -> void:
	curr_pawn = turn_queue.pop_front()
	curr_pawn.finished_turn.connect( on_pawn_turn_finished )
	curr_pawn.toggle_active( true )
	
	# TODO: Figure out how to make the player's allies operate in unison.
	if curr_pawn.get_parent().has_node("FriendlyBrain"):
		var friendly = curr_pawn.get_parent().get_node("FriendlyBrain")
		friendly.operate()
	
	if curr_pawn.get_parent().has_node("EnemyBrain"):
		curr_pawn.get_parent().get_node("EnemyBrain").operate()

func add_pawn(new_pawn: Pawn) -> void:
	current_entities.append( new_pawn )
	turn_queue.append( new_pawn )

func remove_pawn(pawn_to_remove: Pawn) -> void:
	if current_entities.has(pawn_to_remove) == true:
		current_entities.erase( pawn_to_remove )
	if turn_queue.has(pawn_to_remove) == true:
		turn_queue.erase( pawn_to_remove )

## Fired when the dungeon has successfully finished generating.
func on_dungeon_finished_generating() -> void:
	next_pawn()
	on_player_swapped_controlled_character( PlayerPartyController.curr_pawn )

func handle_player_pawns() -> void:
	for pm in PlayerPartyController.party_members:
		pm.toggle_active( true )
		var friendly = pm.get_parent().get_node("FriendlyBrain")
		if friendly != null:
			friendly.operate()

func on_pawn_turn_finished(action: Action) -> void:
	curr_pawn.finished_turn.disconnect( on_pawn_turn_finished )
	curr_pawn.toggle_active( false )
	if turn_queue.size() == 0:
		turn_queue.append_array( current_entities )
	
	next_pawn()

func on_pawn_hp_depleted(stats: Stats) -> void:
	var dead_pawn: Pawn = stats.get_parent().get_node("Pawn")
	remove_pawn( dead_pawn )

func on_advancing_to_next_floor() -> void:
	turn_queue.clear()
	current_entities.clear()

func on_player_swapped_controlled_character(new_controlled_pawn: Pawn) -> void:
	var curr_player_index: int = turn_queue.find(curr_pawn)
	var swapped_index: int     = turn_queue.find(new_controlled_pawn)
	if turn_queue.has(curr_pawn) == false:
		turn_queue.insert(0, curr_pawn)
	if turn_queue.has(new_controlled_pawn) == false:
		turn_queue.insert(1, new_controlled_pawn)
	
	curr_pawn = turn_queue[curr_player_index]
	curr_pawn.finished_turn.disconnect( on_pawn_turn_finished )
	turn_queue[curr_player_index] = new_controlled_pawn
	turn_queue[swapped_index]     = curr_pawn
	curr_pawn = new_controlled_pawn
	new_controlled_pawn.toggle_active( true )
	new_controlled_pawn.finished_turn.connect( on_pawn_turn_finished )
