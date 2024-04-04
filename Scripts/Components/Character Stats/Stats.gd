## A component for storing a characters stats.
class_name Stats extends Node

signal stat_changed(character_stats)

var stats: Dictionary = {}

## Initialize the stats. This base class just gives default values
func initialize() -> void:
	# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		7,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		7,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		5,
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

# TODO: Figure out how to distinguish between ranged.
## Get the physical power for a character.
func get_physical_power() -> int:
	return stats[StatTypes.stat_types.Expertise].get_calculated_value() * 2

## Get the special power for a character.
func get_special_power() -> int:
	return stats[StatTypes.stat_types.Will].get_calculated_value() * 2  
	
func add_modifier(stat_type: StatTypes.stat_types, mod_to_add: StatModifier) -> void:
	stats[stat_type].add_modifier( mod_to_add )
	stat_changed.emit( self )

func remove_modifier(stat_type: StatTypes.stat_types, mod_to_remove: StatModifier) -> void:
	stats[stat_type].remove_modifier( mod_to_remove )
	stat_changed.emit( self )

func take_damage(dmg_amount: int) -> void:
	# TODO: Check for damage types, such as fire, psychic, etc.
	dmg_amount -= round( stats[StatTypes.stat_types.Defense].get_calculated_value() )
	if dmg_amount < 1:
		dmg_amount = 1
		
	stats[StatTypes.stat_types.CurrentHP] -= dmg_amount
	stat_changed.emit( self )
	if stats[StatTypes.stat_types.CurrentHP] <= 0:
		die()

func heal(heal_amount: int) -> void:
	stats[StatTypes.stat_types.CurrentHP] += heal_amount
	if stats[StatTypes.stat_types.CurrentHP] > stats[StatTypes.stat_types.MaxHP].get_calculated_value():
		stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	
	stat_changed.emit( self )
		
func regain_sp(gain_amount: int) -> void:
	stats[StatTypes.stat_types.CurrentSP] += gain_amount
	if stats[StatTypes.stat_types.CurrentSP] > stats[StatTypes.stat_types.MaxSP].get_calculated_value():
		stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
		
	stat_changed.emit( self )

func die() -> void:
	EventBus.hp_depleted.emit( self )
