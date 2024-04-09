## Responsible for listening to characters dying.
class_name DeathHandler extends Node

func _ready() -> void:
	EventBus.hp_depleted.connect( on_pawn_hp_depleted )

func on_pawn_hp_depleted(stats: Stats) -> void:
	# Give experience to the party if it was an enemy that died.
	if stats is EnemyStats:
		var enemy_stats = stats as EnemyStats
		PlayerPartyController.gain_experience(enemy_stats.enemy_data.xp_to_give_on_death)
		pass
	
	# TODO: If the character belongs to the player, remove them from the party.
	stats.get_parent().queue_free()
