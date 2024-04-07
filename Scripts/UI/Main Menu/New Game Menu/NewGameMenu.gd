## Controller for the new game menu.
class_name NewGameMenu extends Node

@export_file("*tscn") var dungeon_scene: String

@export var character_template: PackedScene

@export var character_texture: Texture

## The place where the player can enter the name for their player character.
@export var name_entry: LineEdit

@export var male_button:   Button
@export var female_button: Button

@export var start_button: Button

func _ready() -> void:
	start_button.pressed.connect( on_start_button_pressed )
	
func on_start_button_pressed() -> void:
	if name_entry.get_text().length() < 1:
		return
	
	create_player()
	initialize_new_game_inventory()
	SceneController.switch_to_scene( dungeon_scene )

func initialize_new_game_inventory() -> void:
	PlayerInventory.initialize_slots()
	
	# Testing adding an item.
	var test_item = load("res://Game Data/Items/Test Item.tres")
	var slot_data: ItemSlotData = ItemSlotData.new()
	slot_data.stored_item = test_item
	slot_data.quantity = 50
	PlayerInventory.add_singular_slot_data( slot_data )

## Create the player character once they're done entering everything.
func create_player() -> void:
	var player = character_template.instantiate()
	player.get_node("FactionOwner").set_faction_type( FactionOwner.FactionType.PartyMember )
	var stats: PlayerCharacterStats = PlayerCharacterStats.new()
	stats.set_char_name( name_entry.get_text() )
	stats.name = "Stats"
	stats.initialize()
	player.add_child(stats)
	# TODO: Add friendly brain and disable it so that the player can switch between party members.
	
	# TODO: Proper sprite setting
	var sprite: Sprite2D
	sprite = player.get_node("Character Sprite")
	sprite.set_texture( character_texture )
	sprite.hframes = 8
	sprite.vframes = 8
	sprite.frame   = 8
	
	PlayerPartyController.add_party_member( player.get_node("Pawn") )
	PlayerPartyController.add_child( player )
