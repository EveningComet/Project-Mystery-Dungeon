## Displays an item in an inventory.
class_name ItemSlotUI extends PanelContainer

signal slot_clicked(index: int, button: int)

## The visual that will be displayed.
@export var icon: TextureRect

## Displays the quantity of the item, if able.
@export var amount_label: Label

func set_slot_data(slot_data: ItemSlotData) -> void:
	var item: ItemData = slot_data.stored_item
	
	if slot_data.quantity > 1:
		amount_label.set_text( str(slot_data.quantity) )
		amount_label.show()
	else:
		amount_label.set_text( str(1) )
		amount_label.hide()
