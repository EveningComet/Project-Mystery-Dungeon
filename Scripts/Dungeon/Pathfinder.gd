## Used to help get paths for characters.
class_name Pathfinder extends Node

## The tile map the pathfinding will be based upon.
@export var tile_map: TileMap

## The pathfinding algorithm.
var astar: AStarGrid2D = AStarGrid2D.new()

## Generate the needed data for pathfinding.
func initialize_pathfinding() -> void:
	var tile_map_size = tile_map.get_used_rect().end - tile_map.get_used_rect().position
	astar.region    = tile_map.get_used_rect()
	astar.cell_size = tile_map.tile_set.tile_size
	
	astar.default_compute_heuristic  = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar.update()
	
	print("Pathfinder :: ", tile_map.get_used_rect())
	
	# Check which nodes are walkable
	for x in tile_map_size.x:
		for y in tile_map_size.y:
			var coords: Vector2i = Vector2i(x, y)
			var tile_data = tile_map.get_cell_tile_data(0, coords)
			if tile_data != null and tile_data.get_custom_data("Type") == "Impassable":
				astar.set_point_solid(coords)
