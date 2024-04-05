## A component that is used to tell whomst a character belongs to.
class_name FactionOwner extends Node

enum FactionType
{
	PartyMember, # Owned by the player in some form
	Enemy,       # Enemy
	Neutral      # Not owned by anyone
}

@export var faction_type: FactionType

func set_faction_type(faction_to_set: FactionType) -> void:
	faction_type = faction_to_set
