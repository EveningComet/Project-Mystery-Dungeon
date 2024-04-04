## Responsible for listening to characters dying.
class_name DeathHandler extends Node

func _ready() -> void:
	EventBus.hp_depleted.connect( on_pawn_hp_depleted )

func on_pawn_hp_depleted(stats: Stats) -> void:
	stats.get_parent().queue_free()
