## When the dungeon has been finished generating.
class_name DungeonRunning extends DCState

func enter(msgs: Dictionary = {}) -> void:
	EventBus.player_activated_exit.connect( on_player_activated_exit )
	if OS.is_debug_build() == true:
		print("DungeonRunning :: Entered.")

func exit() -> void:
	EventBus.player_activated_exit.disconnect( on_player_activated_exit )

func on_player_activated_exit() -> void:
	my_state_machine.change_to_state("AdvancingToNextFloor")
