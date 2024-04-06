## Base class for a state that controls how the player should operate at a
## given time in the dungeon.
class_name PDCState extends State

var curr_pawn: Pawn:
	get:
		return my_state_machine.curr_pawn
