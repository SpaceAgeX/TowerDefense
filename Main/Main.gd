extends Node2D

const CAMERA_SPEED = 4

var on = BuildTile.Types.EMPTY
var new_tile_on = false
var remove_building_on = false

var enemy_parts = 40
var production = 0
var enemyCount = 0

@onready var Buildings = $Buildings
@onready var UI = $UI
@onready var Rect = $"ColorRect"
@onready var camera = $Camera2D

func _ready():
	UI.updateCurrency(production, enemy_parts)
	UI.toggleSideBar(true)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_set_min_size(Vector2i(1200, 800))
	
	randomize()
	await get_tree().create_timer(0.1).timeout
	
	for child in $Buildings.get_children():
		child.clicked.connect(on_tile_clicked)


func _physics_process(_delta):
	get_node("Placer").position = Vector2(snapped(get_global_mouse_position().x,64)-32, snapped(get_local_mouse_position().y,64)-32)
	#get_node("Placer").position = Vector2(get_global_mouse_position().x ,get_local_mouse_position().y)
	
	var camera_x = Input.get_axis("camera_left", "camera_right")
	var camera_y = Input.get_axis("camera_up", "camera_down")
	
	camera.position.x += camera_x * CAMERA_SPEED
	camera.position.y += camera_y * CAMERA_SPEED
	
	# Cancels Building Placement
	if Input.is_action_just_pressed("RightClick"):
		cancel_place()
	
	# Places New Build Tile
	if Input.is_action_just_pressed("Click") and new_tile_on:
		var mouse_position = get_global_mouse_position()
		
		UI.toggleSideBar(true)
		new_tile_on = false
		Rect.visible = false
		
		var new_tile = $Buildings.place_build_tile(mouse_position)
		new_tile.clicked.connect(on_tile_clicked)
		
		enemy_parts -= 250
		UI.updateCurrency(production, enemy_parts)



func cancel_place():
		get_node("Placer").visible=false
		Rect.visible = false
		UI.toggleSideBar(true)
		on = BuildTile.Types.EMPTY
		new_tile_on = false
		remove_building_on = false


func on_tile_clicked(tile):
	var selected_tile = get_node("Buildings/" + str(tile))
	
	if selected_tile.placeable:
		selected_tile.type = on
		
		if on == BuildTile.Types.TOWN:
			createTown(selected_tile)
		
		if on == BuildTile.Types.FACTORY:
			production += selected_tile.stats["productionRate"]
			enemy_parts -= 10
			UI.updateCurrency(production, enemy_parts)
			updateTiles()
			
		if on == BuildTile.Types.SILO:
			enemy_parts -= 10
			UI.updateCurrency(production, enemy_parts)
			updateTiles()
		
		UI.toggleSideBar(true)
		
		on = BuildTile.Types.EMPTY
		Rect.visible = false
		get_node("Placer").visible=false
	
	
	if remove_building_on == true:
		#selected_tile.type = BuildTile.Types.EMPTY
		selected_tile.take_damage(selected_tile.stats["health"])
		Rect.visible = false
		remove_building_on = false
		UI.toggleSideBar(true)
	
	
	if on == BuildTile.Types.EMPTY:
		UI.view_stats(selected_tile)
	
	else:
		print("Can't Place Here")
		UI.write_dialogue("Can't Place There", 2)



func _on_town_pressed():
	Rect.visible = true
	UI.toggleSideBar(false)
	get_node("Placer").visible=true
	get_node("Placer").frame=0
	on = BuildTile.Types.TOWN


func _on_factory_pressed():
	if enemy_parts >= 10:
		UI.toggleSideBar(false)
		Rect.visible = true
		get_node("Placer").visible=true
		get_node("Placer").frame=3
		on = BuildTile.Types.FACTORY
		
	else: 
		UI.write_dialogue("You Need 10 Enemy Parts", 3)


func _on_silo_pressed():
	if enemy_parts >= 10:
		UI.toggleSideBar(false)
		Rect.visible = true
		get_node("Placer").visible=true
		get_node("Placer").frame=6
		on = BuildTile.Types.SILO
		
		
	else: 
		UI.write_dialogue("You Need 10 Enemy Parts", 3)


func _on_new_tile_pressed():
	if enemy_parts >= 250:
		UI.toggleSideBar(false)
		Rect.visible = true
		on = BuildTile.Types.EMPTY
		new_tile_on = true
	
	else: 
		UI.write_dialogue("You Need 250 Enemy Parts", 3)


func _on_remove_building_pressed():
		UI.toggleSideBar(false)
		Rect.visible = true
		on = BuildTile.Types.EMPTY
		remove_building_on = true


func createTown(tile):
	var town_position = tile.global_position
	
	$UI/Buttons/Town.disabled = true
	$UI/Buttons/Factory.disabled = false
	$UI/Buttons/Silo.disabled = false
	
	$UI/Buttons/Tile.disabled = false
	$UI/Buttons/Remove.disabled = false
	
	$Enemies.target = town_position
	$Enemies.set_rate()



func on_enemy_killed():
	enemyCount += 1
	enemy_parts += 40
	UI.updateCurrency(production, enemy_parts)
	


func updateTiles():
	var silos = Buildings.get_silos()
	
	if len(silos) != 0:
		var productionEach = production/len(silos)
		for x in silos:
			var silo = get_node("Buildings/" + str(x))
			silo.setRates((15/(productionEach+1)), 1)


