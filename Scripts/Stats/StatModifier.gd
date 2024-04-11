## Stores data for something that modifies a stat.
class_name StatModifier extends Resource

## For convenience, the stat this modifier is changing.
@export var stat_changing: StatTypes.stat_types

## Which type of modifier does this give?
@export var stat_modifier_type: StatModifierTypes.stat_modifier_types

## The modifier's value. Negative ones will subtract/divide the calculation.
@export var value: float = 0.0

## How much priority does this modifier have?
@export var sort_order: int = 0

## Get the value of this modifier
func get_value() -> float:
	return value

## What type of modifier is this?
func get_modifier_type():
	return stat_modifier_type

## Get the sorting order.
func get_sort_order() -> int:
	return sort_order
