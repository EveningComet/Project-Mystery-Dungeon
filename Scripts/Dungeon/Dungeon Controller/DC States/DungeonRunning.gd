## When the dungeon has been finished generating.
class_name DungeonRunning extends DCState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("DungeonRunning :: Entered.")
