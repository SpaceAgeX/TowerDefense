extends Node2D


var on = BuildTile.Types.EMPTY
var new_tile_on = false



var enemy_parts = 10
var production = 0
var enemyCount = 0



var Silos = []

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_set_min_size(Vector2i(1200, 800))
	
	randomize()
	await get_tree().create_timer(0.1).timeout
	
	for child in $Buildings.get_children():
		child.clicked.connect(on_tile_clicked)
	
	$UI/Buttons/Factory.disabled = true
	$UI/Buttons/Silo.disabled = true
	
	


func _physics_process(_delta):
	# Cancels Building Placement
	if Input.is_action_just_pressed("RightClick"):
		cancel_place()
	
	# Places New Build Tile
	if Input.is_action_just_pressed("Click") and new_tile_on:
		var mouse_position = get_global_mouse_position()
		
		$UI/Buttons.visible = true
		$UI/ToggleSideBar.visible = true
		new_tile_on = false
		
		var new_tile = $Buildings.place_build_tile(mouse_position)
		new_tile.clicked.connect(on_tile_clicked)


func cancel_place():
		$UI/Buttons.visible = true
		$UI/ToggleSideBar.visible = true
		on = BuildTile.Types.EMPTY


func on_tile_clicked(tile):
	var selected_tile = get_node("Buildings/" + str(tile))
	
	if selected_tile.placeable:
		selected_tile.type = on
		
		if on == BuildTile.Types.TOWN:
			createTown(selected_tile)
		
		if on == BuildTile.Types.FACTORY:
			production += selected_tile.productionRate
			$UI/Resources/Production.text = "Production: " + str(production) + "/sec"
			
		if on == BuildTile.Types.SILO:
			Silos.append(tile)
		
		$UI/Buttons.visible = true
		$UI/ToggleSideBar.visible = true
		
		on = BuildTile.Types.EMPTY
		
		
	
	if on == BuildTile.Types.EMPTY:
		$UI.view_stats(selected_tile)
	
	else:
		print("Can't Place Here")
		$UI.write_dialogue("Can't Place There", 2)
		
	updateTiles()
	selected_tile.updateType()


func _on_town_pressed():
	$UI/Buttons.visible = false
	$UI/ToggleSideBar.visible = false
	on = BuildTile.Types.TOWN


func _on_factory_pressed():
	if gold >= 10:
		$UI/Buttons.visible = false
		$UI/ToggleSideBar.visible = false
		on = BuildTile.Types.FACTORY
		gold -= 10
		$UI/Resources/Control/Gold.text = "Gold: " + str(gold)
		
		
	else: 
		$UI.write_dialogue("You Need 10 Gold", 3)


func _on_silo_pressed():
	if gold >= 10:
		$UI/Buttons.visible = false
		$UI/ToggleSideBar.visible = false
		on = BuildTile.Types.SILO
		gold -= 10
		$UI/Resources/Control/Gold.text = "Gold: " + str(gold)
		
	else: 
		$UI.write_dialogue("You Need 10 Gold", 3)


func _on_new_tile_pressed():
	$UI/Buttons.visible = false
	$UI/ToggleSideBar.visible = false
	on = BuildTile.Types.EMPTY
	new_tile_on = true


func createTown(tile):
	var town_position = tile.global_position
	
	$UI/Buttons/Town.disabled = true
	$UI/Buttons/Factory.disabled = false
	$UI/Buttons/Silo.disabled = false
	$Enemies.target = town_position
	$Enemies.set_rate()



func killed():
	enemyCount += 1
	gold += 5
	$UI/Resources/Control/Gold.text = "Gold: " + str(gold)


func updateTiles():
	pass
	# find Equation decide the missile cooldown based on the amount of production
			
