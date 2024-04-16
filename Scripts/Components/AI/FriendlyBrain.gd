class_name FriendlyBrain extends AIBrain

## The current character the player is controlling.
var player: Pawn
var player_currently_controlling: bool = false

@onready var follow_player_behavior: UtilityAIBehavior = preload("res://Game Data/Behaviors/Follow Player.tres")
@onready var friendly_wait: UtilityAIBehavior = preload("res://Game Data/Behaviors/Friendly Wait.tres")

func set_player(new_player: Pawn) -> void:
	player = new_player
	
func toggle_player_controlling(new_status: bool) -> void:
	player_currently_controlling = new_status

func operate() -> void:
	if player_currently_controlling == true:
		return
	
	if player == null:
		get_parent().get_node("Pawn").finished_turn.emit( null )
		return

	# Time to decide what to do
	var choices: Array[UtilityAIOption] = []
	
	var potential_action: Action = Action.new()
	potential_action.action_type = Action.ActionTypes.FollowPlayer
	
	# Used by the AI to make a decision
	var context: Dictionary = {
		"distance_from_player": get_parent().global_position.distance_to( player.get_parent().global_position),
		"my_hp": get_parent().get_node("Stats").stats[StatTypes.stat_types.CurrentHP],
		"num_enemies_nearby": 0
	}
	
	var choice = UtilityAIOption.new(
		follow_player_behavior, context, potential_action
	)
	choices.append( choice )
	
	potential_action = Action.new()
	potential_action.action_type = Action.ActionTypes.Wait
	choice = UtilityAIOption.new(
		friendly_wait, context, potential_action
	)
	choices.append(choice)
	
	var decision = UtilityAI.choose_highest( choices, 0.9 )
	
	var chosen_action: Action = decision.action as Action
	match chosen_action.action_type:
		Action.ActionTypes.FollowPlayer:
			path = pathfinder.astar.get_id_path(
				pathfinder.tile_map.local_to_map( get_parent().global_position ), 
				pathfinder.tile_map.local_to_map( player.get_parent().global_position )
			).slice(1)
			
			if path.size() == 1:
				get_parent().get_node("Pawn").finished_turn.emit(chosen_action)
				return
			
			if path.is_empty() == true:
				get_parent().get_node("Pawn").finished_turn.emit(chosen_action)
				return
			
			var dir = (path[0] - pathfinder.tile_map.local_to_map(get_parent().global_position))
			get_parent().get_node("Pawn").update_raycast(dir)
			if get_parent().get_node("Pawn").ray.is_colliding() == true:
				get_parent().get_node("Pawn").finished_turn.emit(chosen_action)
				return
			
			var p = pathfinder.tile_map.map_to_local(path[0])
			get_parent().get_node("Mover").move( p )
		
		Action.ActionTypes.Wait:
			get_parent().get_node("Pawn").finished_turn.emit(chosen_action)
			return
