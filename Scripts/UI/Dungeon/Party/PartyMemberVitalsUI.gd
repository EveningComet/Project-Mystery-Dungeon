## Displays the current health and special points of a player's party member.
class_name PartyMemberVitalsUI extends Control

@export var hp_text:   Label
@export var sp_text:   Label
@export var char_name: Label

## The character this UI is monitoring.
var party_member: PlayerCharacterStats

## Set the party member and subscribe to their stat changed variable.
func set_party_member(new_pm: PlayerCharacterStats) -> void:
	if party_member != null:
		party_member.stat_changed.disconnect( on_stat_changed )
	party_member = new_pm
	char_name.set_text(party_member.char_name)
	party_member.stat_changed.connect( on_stat_changed )
	update_hp_display()
	update_sp_display()

func on_stat_changed(stats: Stats) -> void:
	update_hp_display()
	update_sp_display()

func update_hp_display() -> void:
	hp_text.set_text(
		"HP: %s / %s" % [party_member.stats[StatTypes.stat_types.CurrentHP],
		party_member.stats[StatTypes.stat_types.MaxHP].get_calculated_value()]
	)

func update_sp_display() -> void:
	sp_text.set_text(
		"SP: %s / %s" % [party_member.stats[StatTypes.stat_types.CurrentSP],
		party_member.stats[StatTypes.stat_types.MaxSP].get_calculated_value()]
	)
