## Responsible for keeping track of the player's party.
extends Node

## The max amount of characters the player can have in their party.
const MAX_RECRUITED_PARTY_SIZE: int = 4
# TODO: Summoning?

var party_members: Array[Pawn] = []

func gain_experience(xp_to_give: int) -> void:
	for pm in party_members:
		pm.get_parent().get_node("Stats").gain_experience( xp_to_give )

func get_party_count() -> int:
	return party_members.size()

func add_party_member(new_pm: Pawn) -> void:
	party_members.append( new_pm )

func remove_party_member(pm_to_remove: Pawn) -> void:
	party_members.erase( pm_to_remove )
