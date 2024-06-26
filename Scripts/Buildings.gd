extends TileMap


@onready var build_tile_scene = preload("res://BuildTile/Build_tile.tscn")


func is_adjacent_to_existing_tiles(pos) -> bool:
	var x_position = floor(pos.x/64)*16
	var y_position = floor(pos.y/64)*16
	var tile_position = Vector2i(x_position+8, y_position+8)
	
	for tile in self.get_children():
		if tile.position.x == tile_position.x and tile.position.y == tile_position.y:
			return false
		
		var x_adjacent = tile_position.x == tile.position.x + 16 or tile_position.x == tile.position.x - 16
		var y_adjacent = tile_position.y == tile.position.y + 16 or tile_position.y == tile.position.y - 16
		
		if x_adjacent and y_adjacent:
			return true
	
	return false


func place_build_tile(pos):
	var x_position = floor(pos.x/64)*16
	var y_position = floor(pos.y/64)*16
	
	print("Snapping Functionality: ", pos, " -> ", Vector2(x_position, y_position))
	
	var new_tile = build_tile_scene.instantiate()
	self.add_child(new_tile)
	
	new_tile.position = Vector2i(x_position+8, y_position+8)
	new_tile.name = "NewBuildTile"
	
	return new_tile


func get_nearest_building(pos):
	if self.get_child_count() > 0:
		var nearest = Node2D.new()
		nearest.position = Vector2(100_000, 100_000)
		
		for building in self.get_children():
			var closer_than_nearest = building.global_position.distance_to(pos) < nearest.global_position.distance_to(pos)
			var is_not_empty =  building.type != BuildTile.Types.EMPTY and building.type != 0 and building.type != BuildTile.Types.DESTROY
			
			if is_not_empty and closer_than_nearest:
				nearest = building
		
		return nearest
	
	return null


func get_random_building():
	if self.get_child_count() > 0:
		var buildings = []
		
		for building in self.get_children():
			if building.type != BuildTile.Types.EMPTY:
				buildings.append(building)
		
		return buildings[randi_range(0, len(buildings)-1)]
	
	return null


func get_silos():
	var silos = []
	
	for building in self.get_children():
		if building.type == BuildTile.Types.SILO:
			silos.append(building)
	
	return silos
