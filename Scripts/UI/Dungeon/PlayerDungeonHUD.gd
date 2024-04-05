## Displays the current party to the player.
class_name PlayerDungeonHUD extends Control

## The prefab of the UI that will display the vitals of the party member.
@export var party_member_vitals_template: PackedScene

## The node storing the characters.
@export var party_container_node: Control

func _ready() -> void:
	if party_container_node.get_child_count() > 0:
		clear_party_display()

func create_display_for_pm(new_pm: PlayerCharacterStats) -> void:
	var pmvd: PartyMemberVitalsUI = party_member_vitals_template.instantiate()
	party_container_node.add_child( pmvd )
	pmvd.set_party_member( new_pm )

func clear_party_display() -> void:
	for c in party_container_node.get_children():
		c.queue_free()
