## A component for storing a characters stats.
class_name Stats extends Node

signal stat_changed(character_stats)

var stats: Dictionary = {}

func take_damage(damage_amount: int) -> void:
	die()

func die() -> void:
	EventBus.hp_depleted.emit( self )
