## Manages the displaying of stats for a party member.
class_name CharacterStatsMenu extends Control

@export var char_level:     CharacterStatDisplayer
@export var vitality_stat:  CharacterStatDisplayer
@export var expertise_stat: CharacterStatDisplayer
@export var will_stat:      CharacterStatDisplayer
@export var defense_stat:   CharacterStatDisplayer

## The stats of the current pawn we will display.
var current_stats: PlayerCharacterStats

func set_stats_to_display(new_stats: PlayerCharacterStats) -> void:
	if current_stats != null:
		current_stats.stat_changed.disconnect( on_stat_changed )
	current_stats = new_stats
	current_stats.stat_changed.connect( on_stat_changed )
	on_stat_changed( current_stats )

func on_stat_changed(stats: Stats) -> void:
	char_level.update_display("Level", str(current_stats.curr_level))
	vitality_stat.update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Vitality],
		str(current_stats.stats[StatTypes.stat_types.Vitality].get_calculated_value())
	)
	expertise_stat.update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Expertise],
		str(current_stats.stats[StatTypes.stat_types.Expertise].get_calculated_value())
	)
	will_stat.update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Will],
		str(current_stats.stats[StatTypes.stat_types.Will].get_calculated_value())
	)
	defense_stat.update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Defense],
		str(current_stats.get_defense())
	)
