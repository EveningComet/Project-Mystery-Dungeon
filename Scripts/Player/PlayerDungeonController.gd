## Manages the player in the dungeon controller.
class_name PlayerDungeonController extends Node
# TODO: This needs to be converted to a state machine.

@export var camera_controller: CameraController
@export var tile_map: TileMap

@export var party_management_menu: PartyManagementMenu

## The character the player is currently controlling.
var curr_pawn: Pawn

var inputs: Dictionary = {
	"move_up": Vector2.UP,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT
}

func _unhandled_input(event) -> void:
	if curr_pawn == null or curr_pawn.my_turn == false:
		return
	
	# Handle switching of party members
	swap_controlled_party_member(event)
	
	if event.is_action_pressed("toggle_party_management_screen"):
		party_management_menu.visible = !party_management_menu.visible
	
	# Do not allow any actions while the menu is open.
	# TODO: Make it so that any menu is open?
	if party_management_menu.visible == true:
		return
	
	if curr_pawn.ground_interactable_standing_over != null and event.is_action_pressed("ui_accept"):
		EventBus.player_activated_exit.emit()
		return
	
	# Handling of movement
	for dir in inputs.keys():
		if event.is_action(dir):
			var curr_pos = tile_map.local_to_map( curr_pawn.get_parent().global_position )
			var tile_data = tile_map.get_cell_tile_data(0, curr_pos + Vector2i(inputs[dir]))
			
			curr_pawn.update_raycast( inputs[dir] )
			if curr_pawn.ray.is_colliding() == true:
				var col = curr_pawn.ray.get_collider()
				var my_faction_owner: FactionOwner = curr_pawn.get_parent().get_node("FactionOwner")
				if curr_pawn.ray.get_collider().has_node("FactionOwner"):
					var t = curr_pawn.ray.get_collider().get_node("FactionOwner")
					
					# See if it's an enemy
					if my_faction_owner.faction_type == FactionOwner.FactionType.PartyMember and t.faction_type == FactionOwner.FactionType.Enemy:
						col.get_node("Stats").take_damage( 50 )
						curr_pawn.finished_turn.emit(null)
						return
					
					# See if it's a potential ally
					if t.faction_type == FactionOwner.FactionType.Neutral and col.has_node("Stats"):
						if PlayerPartyController.get_party_count() < PlayerPartyController.MAX_RECRUITED_PARTY_SIZE and col.get_node("Stats") is PlayerCharacterStats:
							PlayerPartyController.add_party_member( col.get_node("Pawn") )
							EventBus.character_added_to_party.emit( col.get_node("Stats") )
							col.get_node("FriendlyBrain").set_player( curr_pawn )
							col.get_node("FactionOwner").set_faction_type(FactionOwner.FactionType.PartyMember)
							return
			
			# If we can move to the position, go for it
			if tile_data != null and tile_data.get_custom_data("Type") != "Impassable":
				var target_pos: Vector2 = tile_map.map_to_local( curr_pos + Vector2i(inputs[dir]))
				curr_pawn.get_parent().get_node("Mover").move(target_pos)

## Set the current pawn the player will be controlling and disable that pawn's
## AI brain.
func set_current_pawn(new_curr_pawn: Pawn) -> void:
	curr_pawn = new_curr_pawn
	camera_controller.set_target( curr_pawn.get_parent() )

func swap_controlled_party_member(event: InputEvent) -> void:
	if PlayerPartyController.get_party_count() == 1:
		return
	var swapping = false
	if event.is_action_pressed("swap_right"):
		var curr_index = PlayerPartyController.party_members.find( curr_pawn )
		curr_index += 1
		if curr_index > PlayerPartyController.get_party_count() - 1:
			curr_index = 0
		curr_pawn.get_parent().get_node("FriendlyBrain").toggle_player_controlling(false)
		set_current_pawn(PlayerPartyController.party_members[curr_index])
		EventBus.player_swapped_controlled_character.emit( curr_pawn )
		swapping = true
	elif event.is_action_pressed("swap_left"):
		var curr_index = PlayerPartyController.party_members.find( curr_pawn )
		curr_index -= 1
		if curr_index < 0:
			curr_index = PlayerPartyController.get_party_count() - 1
		curr_pawn.get_parent().get_node("FriendlyBrain").toggle_player_controlling(false)
		set_current_pawn( PlayerPartyController.party_members[curr_index] )
		EventBus.player_swapped_controlled_character.emit( curr_pawn )
		swapping = true
	
	if swapping == true:
		PlayerPartyController.set_current_pawn( curr_pawn )
		curr_pawn.get_parent().get_node("FriendlyBrain").toggle_player_controlling(true)
		for pm in PlayerPartyController.party_members:
			var friendly = pm.get_parent().get_node("FriendlyBrain")
			if pm != curr_pawn:
				if OS.is_debug_build() == true:
					print("PlayerDungeonController :: New player is being set for party member.")
				friendly.set_player( curr_pawn )
