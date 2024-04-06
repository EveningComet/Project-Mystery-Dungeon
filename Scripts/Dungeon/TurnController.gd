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
	EventBus.character_spawned_in_dungeon.connect( on_pawn_spawned )

func on_pawn_spawned(new_pawn: Pawn) -> void:
	add_pawn( new_pawn )

func next_pawn() -> void:
	curr_pawn = turn_queue.pop_front()
	curr_pawn.finished_turn.connect( on_pawn_turn_finished )
	curr_pawn.toggle_active( true )
	
	if curr_pawn.get_parent().has_node("FriendlyBrain"):
		var friendly = curr_pawn.get_parent().get_node("FriendlyBrain")
		friendly.operate()
	
	elif curr_pawn.get_parent().has_node("EnemyBrain"):
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

func on_pawn_turn_finished(action: Action) -> void:
	curr_pawn.finished_turn.disconnect( on_pawn_turn_finished )
	curr_pawn.toggle_active( false )
	if turn_queue.size() == 0:
		turn_queue.append_array( current_entities )
	
	next_pawn()

func on_pawn_hp_depleted(stats: Stats) -> void:
	var dead_pawn: Pawn = stats.get_parent().get_node("Pawn")
	remove_pawn( dead_pawn )
