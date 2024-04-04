class_name EnemyBrain extends AIBrain

func operate() -> void:
	get_parent().get_node("Pawn").finished_turn.emit( null )
