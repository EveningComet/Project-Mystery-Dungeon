## A component that is used to tell whomst a character belongs to.
class_name FactionOwner extends Node

enum FactionType
{
	PartyMember, # Owned by the player in some form
	Enemy,       # Enemy
	Neutral      # Not owned by anyone
}

@export var faction_type: FactionType
