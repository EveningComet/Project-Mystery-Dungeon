## A class responsible for passing around needed data to objects that want to know
## the same thing.
extends Node

## Fired when a character has lost all their health.
signal hp_depleted(stats: Stats)

signal character_spawned_in_dungeon(character: Pawn)
