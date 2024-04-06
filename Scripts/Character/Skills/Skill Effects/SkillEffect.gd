## Defines what a skill can do.
class_name SkillEffect extends Resource

@export var power_scale: float = 1.0

@export var uses_special_stat: bool = false

func execute(activator, targets) -> void:
	pass

func get_physical_power(activator) -> int:
	return 0

func get_special_power(activator) -> int:
	return 0
