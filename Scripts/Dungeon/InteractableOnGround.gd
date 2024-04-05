## An interactable object that exists on a tile.
class_name InteractableOnGround extends Area2D

func _ready() -> void:
	body_entered.connect( on_body_entered )
	body_exited.connect( on_body_exited )

func on_body_entered(body) -> void:
	if body.has_node("Pawn"):
		var pawn: Pawn = body.get_node("Pawn")
		pawn.set_interactable_standing_over( self )

func on_body_exited(body) -> void:
	if body.has_node("Pawn"):
		var pawn: Pawn = body.get_node("Pawn")
		pawn.set_interactable_standing_over( null )
