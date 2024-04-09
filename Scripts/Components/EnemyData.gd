## Stores data for an enemy.
class_name EnemyData extends Resource

@export var localization_name: String = "New Enemy"

## The skills this enemy is allowed to use.
@export var skills: Array[SkillData] = []

@export var starting_vitality:  int = 5
@export var starting_expertise: int = 5
@export var starting_will:      int = 5

@export var xp_to_give_on_death: int = 100
