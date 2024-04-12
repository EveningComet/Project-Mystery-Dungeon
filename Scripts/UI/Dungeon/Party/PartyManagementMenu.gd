## Handles displaying the player's party, the stats and equipment of
## a character, and the player's current inventory.
class_name PartyManagementMenu extends Control

@export var equipment_menu: EquipmentMenu

## Reference to the menu that will display the currently desired character's
## stats.
@export var character_stats_menu: CharacterStatsMenu

@export var player_inventory_ui: InventoryDisplayer

## Reference to the node housing the player's inventory.
var player_inventory: Inventory

var equipment_inventory: EquipmentInventory

# Inventory middleman/item dragging and dropping
## Used to display a grabbed slot to the player.
@export var grabbed_slot_ui: ItemSlotUI
var grabbed_slot_data: ItemSlotData = null
var original_index: int = 0 # Used to prevent losing items to the garbage collector

func _ready() -> void:
	EventBus.player_swapped_controlled_character.connect( on_player_swapped_controlled_character )
	visibility_changed.connect( on_visibility_changed )
	hide()

func initialize_player_inventory(inventory: Inventory) -> void:
	player_inventory = inventory
	player_inventory_ui.set_inventory_to_display( player_inventory )
	inventory.inventory_interacted.connect( on_inventory_interacted )

func on_dungeon_finished_generating() -> void:
	# Setup the scene using the player's inventory
	initialize_player_inventory( PlayerInventory )
	
	# TODO: Set this up cleaner.
	set_party_member_equipment_to_display(PlayerPartyController.curr_pawn)

func _input(event: InputEvent) -> void:
	if grabbed_slot_ui.visible == true:
		# Display the grabbed slot where the mouse is, with an offset 
		grabbed_slot_ui.global_position = get_global_mouse_position() + Vector2(5, 5)

func on_visibility_changed() -> void:
	if visible == false and grabbed_slot_data != null:
		player_inventory.drop_slot_data(grabbed_slot_data, original_index)
		grabbed_slot_data = null
		update_grabbed_slot()

func on_inventory_interacted(inventory_data: Inventory, index: int, button: int) -> void:
	if OS.is_debug_build() == true:
		print("PartyManagementMenu :: Clicked on: ", inventory_data.stored_items[index])
	
	match[grabbed_slot_data, button]:
		# The player wants to grab the whole item
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		
		# The player wants to drop the item in a new slot
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		
		# Attempt to use the item
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data( index )
		
		# Player is trying to drop a piece of the slot
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	# Update the grabbed slot based on the player's input
	update_grabbed_slot()

## Handle displaying a slot the player currently has grabbed.
func update_grabbed_slot() -> void:
	if grabbed_slot_data != null:
		grabbed_slot_ui.global_position = get_global_mouse_position()
		grabbed_slot_ui.show()
		grabbed_slot_ui.set_slot_data( grabbed_slot_data)
	else:
		grabbed_slot_ui.hide()

func set_party_member_equipment_to_display(new_pawn: Pawn) -> void:
	equipment_menu.name_label.set_text( new_pawn.get_parent().get_node("Stats").char_name )
	if equipment_inventory != null:
		equipment_inventory.inventory_interacted.disconnect( on_inventory_interacted )
	equipment_inventory = new_pawn.get_parent().get_node("EquipmentInventory")
	equipment_menu.set_equipment_inventory( equipment_inventory )
	equipment_inventory.inventory_interacted.connect( on_inventory_interacted )

func on_player_swapped_controlled_character(new_pawn: Pawn) -> void:
	set_party_member_equipment_to_display( new_pawn )
