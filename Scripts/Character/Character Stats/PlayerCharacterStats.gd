class_name PlayerCharacterStats extends Stats

var char_name: String = "New Friend"

## Used to both set and initialize a character with stats from a character class.
var character_class: CharacterClass:
	get:
		return character_class
	set(value):
		character_class = value
		initialize_with_character_class( character_class )

var curr_level:              int = 1
var curr_experience_points:  int = 0
var experience_required:     int = get_experience_required( curr_level )
var total_experience_points: int = 0

## When a character levels up, this dictates the scale for how many experience
## points are required for the next level up.
const EXPERIENCE_GROWTH_PERCENTAGE: float = 1.10

func set_char_name(new_name: String) -> void:
	char_name = new_name

func initialize_with_character_class(job: CharacterClass) -> void:
	# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		job.starting_vitality,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		job.starting_expertise,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		job.starting_will,
		true
	)
	
	# Vitals
	stats[StatTypes.stat_types.MaxHP] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	stats[StatTypes.stat_types.MaxSP] = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
	
	# Other stats
	stats[StatTypes.stat_types.Defense] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 2,
		true
	)

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
	
	if OS.is_debug_build() == true:
		print("PlayerCharacterStats :: %s has leveled up!" % [char_name])
	
	# Boost attributes based on the character's class
	stats[StatTypes.stat_types.Vitality].raise_base_value_by(
		character_class.vitality_on_increase
	)
	stats[StatTypes.stat_types.Expertise].raise_base_value_by(
		character_class.expertise_on_increase
	)
	stats[StatTypes.stat_types.Will].raise_base_value_by(
		character_class.vitality_on_increase
	)
	
	# Boost the rest of the stats
	# TODO: This is nasty. Don't do this.
	# Vitals
	stats[StatTypes.stat_types.MaxHP] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	stats[StatTypes.stat_types.MaxSP] = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
	
	# Other stats
	stats[StatTypes.stat_types.Defense] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 2,
		true
	)
	
	stat_changed.emit( self )
