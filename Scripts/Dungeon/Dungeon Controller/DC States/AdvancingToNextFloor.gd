## State for when the player has interacted with the object that makes them go
## onto the next floor in the dungeon.
class_name AdvancingToNextFloor extends DCState

@export_file("*.tscn") var dungeon_scene: String

func enter(msgs: Dictionary = {}) -> void:
	advance_to_next_floor()
	if OS.is_debug_build() == true:
		print("AdvancingToNextFloor :: Entered.")

func exit() -> void:
	pass

func advance_to_next_floor() -> void:
	# Reparent the living party members so that they can safely follow
	for party_member in PlayerPartyController.party_members:
		party_member.get_parent().reparent( PlayerPartyController )
	
	my_state_machine.turn_controller.turn_queue.clear()
	my_state_machine.turn_controller.current_entities.clear()
	tile_map.clear()
	
	SceneController.switch_to_scene( dungeon_scene )
