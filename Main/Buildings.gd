extends TileMap

@onready var build_tile_scene = preload("res://BuildTile/Build_tile.tscn")


func place_build_tile(pos):
	var x_position = floor(pos.x/64)*16
	var y_position = floor(pos.y/64)*16
	
	print(position, " -> ", Vector2(x_position, y_position))
	
	var new_tile = build_tile_scene.instantiate()
	self.add_child(new_tile)
	
	new_tile.position = Vector2i(x_position+8, y_position+8)
	new_tile.name = "NewBuildTile"
	
	return new_tile


# Might Be Inaccurate for reasons I'm still not sure of
func get_nearest_building(pos):
	if self.get_child_count() != 0:
		var nearest = self.get_child(0)
		
		for building in self.get_children():
			var closer_than_nearest = building.position.distance_to(pos) < nearest.position.distance_to(pos)
			var is_not_empty =  building.type != BuildTile.Types.EMPTY
			
			if is_not_empty and closer_than_nearest:
				nearest = building
		
		return nearest
	
	return null
