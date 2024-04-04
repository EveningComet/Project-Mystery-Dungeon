class_name PlayerCharacterStats extends Stats

var curr_level:              int = 1
var curr_experience_points:  int = 0
var experience_required:     int = get_experience_required( curr_level )
var total_experience_points: int = 0

## When a character levels up, this dictates the scale for how many experience
## points are required for the next level up.
const EXPERIENCE_GROWTH_PERCENTAGE: float = 1.10

## Return how much experience is required for this character to level up.
## Calculation is: 100 * (growth_percent^( current level - 1))
func get_experience_required(level: int) -> int:
	return round( 100 * pow(EXPERIENCE_GROWTH_PERCENTAGE, level - 1) )

## Give this character experience points.
func gain_experience(gain_amount: int) -> void:
	total_experience_points += gain_amount
	curr_experience_points += gain_amount
	var growth_data: Array = []
	
	# While the experience is high enough, keep leveling up.
	while curr_experience_points >= experience_required:
		curr_experience_points -= experience_required
		growth_data.append( [experience_required, experience_required] )
		level_up()
	growth_data.append( [curr_experience_points, experience_required] )
	
	# Notify anything about the change in experience
	#experience_gained.emit( growth_data )

## Boost this character's level.
func level_up() -> void:
	
	# Boost the level and the required experience for the next level
	curr_level += 1
	experience_required = get_experience_required( curr_level )
	
	# Boost stats based on the character's class
