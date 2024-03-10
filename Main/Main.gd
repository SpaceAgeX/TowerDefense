extends Node2D

@onready var build_tile_scene = preload("res://BuildTile/Build_tile.tscn")

var on = BuildTile.Types.EMPTY
var new_tile_on = false

var production = 0
var enemyCount = 0
var gold = 0


var Silos = []
func _ready():
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	randomize()
	await get_tree().create_timer(0.1).timeout
	
	for child in $Buildings.get_children():
		child.clicked.connect(on_tile_clicked)
	
	$UI/Buttons/Factory.disabled = true
	$UI/Buttons/Silo.disabled = true
	


func _physics_process(_delta):
	if Input.is_action_just_pressed("RightClick"):
		cancel_place()
	
	if Input.is_action_just_pressed("Click") and new_tile_on:
		var mouse_position = get_global_mouse_position()
		place_build_tile(mouse_position)


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


func place_build_tile(pos):
	var x_position = floor(pos.x/64)*16
	var y_position = floor(pos.y/64)*16

	$UI/Buttons.visible = true
	$UI/ToggleSideBar.visible = true
	new_tile_on = false
	print(position, " -> ", Vector2(x_position, y_position))
	
	#$Buildings.set_cell(0, Vector2i(4, 0), 0, )
	var new_tile = build_tile_scene.instantiate()
	$Buildings.add_child(new_tile)
	
	new_tile.position = Vector2i(x_position+8, y_position+8)
	new_tile.name = "NewBuildTile"
	new_tile.clicked.connect(on_tile_clicked)


func _on_town_pressed():
	$UI/Buttons.visible = false
	$UI/ToggleSideBar.visible = false
	on = BuildTile.Types.TOWN


func _on_factory_pressed():
	$UI/Buttons.visible = false
	$UI/ToggleSideBar.visible = false
	on = BuildTile.Types.FACTORY


func _on_silo_pressed():
	$UI/Buttons.visible = false
	$UI/ToggleSideBar.visible = false
	on = BuildTile.Types.SILO


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
	gold = enemyCount
	$UI/Resources/Control/Gold.text = "Gold: " + str(gold)


func updateTiles():
	var productionEach = production/len(Silos)
	for x in Silos:
		get_node("Buildings/" + str(x)).getRates(3*(1/productionEach),1)
	
			
