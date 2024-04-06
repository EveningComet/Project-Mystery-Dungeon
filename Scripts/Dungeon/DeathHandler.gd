## Responsible for listening to characters dying.
class_name DeathHandler extends Node

func _ready() -> void:
	EventBus.hp_depleted.connect( on_pawn_hp_depleted )

func on_pawn_hp_depleted(stats: Stats) -> void:
	stats.get_parent().queue_free()
	# TODO: Give experience to the party if it was an enemy that died.
	# TODO: If the character belongs to the player, remove them from the party.
