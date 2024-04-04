## A class responsible for passing around needed data to objects that want to know
## the same thing.
extends Node

## Fired when a character has died
signal hp_depleted(stats: Stats)
