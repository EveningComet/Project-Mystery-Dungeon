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
	
	# Vitals
	stats[StatTypes.stat_types.MaxHP] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	stats[StatTypes.stat_types.MaxSP] = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
	
	# Other stats
	stats[StatTypes.stat_types.Defense] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 2,
		true
	)
	
