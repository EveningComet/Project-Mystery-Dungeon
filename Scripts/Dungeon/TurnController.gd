## Keeps track of what character should be allowed to do anything at a given time.
class_name TurnController extends Node

## The current characters in the game world.
var current_entities: Array[Pawn] = []

var turn_queue: Array[Pawn] = []

## The current character's turn.
var curr_pawn: Pawn = null

func next_pawn() -> void:
	curr_pawn = turn_queue.pop_front()
	curr_pawn.finished_turn.connect( on_pawn_turn_finished )
	curr_pawn.toggle_active()
	if curr_pawn.get_parent().has_node("Friendly"):
		var friendly = curr_pawn.get_parent().get_node("Friendly")
		friendly.operate()

func add_pawn(new_pawn: Pawn) -> void:
	current_entities.append( new_pawn )
	turn_queue.append( new_pawn )

func remove_pawn(pawn_to_remove: Pawn) -> void:
	current_entities.erase( pawn_to_remove )
	turn_queue.erase( pawn_to_remove )

func on_pawn_turn_finished(action: Action) -> void:
	curr_pawn.finished_turn.disconnect( on_pawn_turn_finished )
	curr_pawn.toggle_active()
	if turn_queue.size() == 0:
		turn_queue.append_array( current_entities )
	
	next_pawn()
