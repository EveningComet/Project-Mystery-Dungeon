## Handles displaying the player's party, the stats and equipment of
## a character, and the player's current inventory.
class_name PartyManagementMenu extends Control

## Used to create the menu for party members at runtime.
@export var equipment_menu_template: PackedScene

@export var equipment_menu_holder: Control

## Reference to the menu that will display the currently desired character's
## stats.
@export var character_stats_menu: CharacterStatsMenu

@export var player_inventory_ui: InventoryDisplayer

## Reference to the node housing the player's inventory.
var player_inventory: Inventory

func _ready() -> void:
	EventBus.dungeon_finished_generating.connect( on_dungeon_finished_generating )
	hide()

func initialize(inventory: Inventory) -> void:
	player_inventory = inventory
	player_inventory_ui.set_inventory_to_display( player_inventory )

func on_dungeon_finished_generating() -> void:
	# Setup the scene using the player's inventory
	initialize( PlayerInventory )
	
	# Generate the needed panels for the party members
	var equipment_menu: EquipmentMenu = equipment_menu_template.instantiate()
	equipment_menu_holder.add_child( equipment_menu )
	equipment_menu.name_label.set_text( PlayerPartyController.party_members[0].get_parent().get_node("Stats").char_name )
	
