## Component for enemy stats.
class_name EnemyStats extends Stats

## Stores the data for this character.
var enemy_data: EnemyData

func initialize_enemy(ed: EnemyData) -> void:
	enemy_data = ed
	
		# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		enemy_data.starting_vitality,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		enemy_data.starting_expertise,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		enemy_data.starting_will,
		true
	)
	
	initialize_vitals()
	initialize_other_stats()
	
