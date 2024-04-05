## A class responsible for passing around needed data to objects that want to know
## the same thing. It also handles events that would be very tedious to pass along.
extends Node

## Fired when a character has lost all their health.
signal hp_depleted(stats: Stats)

signal character_spawned_in_dungeon(character: Pawn)

signal character_added_to_party(new_pm: PlayerCharacterStats)

## For when the player activated the exit and wants to proceed to the next floor.
signal player_activated_exit
