## Data associated with skills. Could be passive or something that needs to be
## activated.
class_name SkillData extends Resource

## The name for the skill.
@export var localization_name: String = "New Skill"

## The description for this skill.
@export_multiline var localization_description: String = "New description."

@export var is_passive: bool = false

## The effects that define what a skill does.
@export var effects: Array[SkillEffect] = []

func execute(activator, target: Array) -> void:
	pass
