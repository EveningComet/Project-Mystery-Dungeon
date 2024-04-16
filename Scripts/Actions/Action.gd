## Base class for something a character can do in the dungeon.
class_name Action

## The character that the action is for.
var actioner

var action_type: Action.ActionTypes

enum ActionTypes {
	FollowPlayer,
	
	## Action for when the AI has nothing else to do. For example, an ally is
	## within a few tiles away from the player.
	Wait,
	
	FightEnemy
}
