## Displays equipment for a party member.
class_name EquipmentMenu extends Control

## Used to display the character's name.
@export var name_label: Label

@export var equipment_displayer: InventoryDisplayer

var equipment_inventory: EquipmentInventory

func set_equipment_inventory(equipment_data: EquipmentInventory) -> void:
	equipment_inventory = equipment_data
	equipment_displayer.set_inventory_to_display( equipment_inventory )
