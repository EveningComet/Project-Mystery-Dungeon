## Defines a state in the dungeon controller.
class_name DCState extends State

## Everystate here will want to keep track of the tile map.
var tile_map: TileMap

func setup_state(new_sm: DungeonController) -> void:
	super( new_sm )
	tile_map = new_sm.tile_map
