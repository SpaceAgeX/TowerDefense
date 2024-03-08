extends Node2D

enum Buttons {
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var on = Buttons.EMPTY


var TownPosition = Vector2.ZERO


var Building
@onready var Display = $UI/HUD/Display

func _ready():
	randomize()
	await get_tree().create_timer(0.1).timeout
	
	for x in $Buildings.get_children():
		x.clicked.connect(on_clicked)
	
	$UI/Buttons/Factory.disabled = true
	$UI/Buttons/Silo.disabled = true
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("RightClick"):
		$UI/Buttons.visible = true
		on = Buttons.EMPTY
		cancel_place()



func cancel_place():
	pass



func on_clicked(tile):
	Building = get_node("Buildings/"+str(tile))
	
	if Building.placeable:
		match on:
			Buttons.EMPTY:
				Building.type = Building.Types.EMPTY
				
			Buttons.TOWN:
				Building.type = Building.Types.TOWN
				town()
				
			Buttons.FACTORY:
				Building.type = Building.Types.FACTORY
			Buttons.SILO:
				Building.type = Building.Types.SILO
		$UI/Buttons.visible = true
		on = Buttons.EMPTY
	else:
		$UI/HUD/Display.write("Can't Place There", 2)
	
	Building.updateType()


func _on_town_pressed():
	$UI/Buttons.visible = false
	on = Buttons.TOWN
func _on_factory_pressed():
	$UI/Buttons.visible = false
	on = Buttons.FACTORY
func _on_silo_pressed():
	
	
	
	$UI/Buttons.visible = false
	on = Buttons.SILO


func cancel_place():
	pass

func town():
	TownPosition = Building.position
	$UI/Buttons/Town.disabled = true
	$UI/Buttons/Factory.disabled = false
	$UI/Buttons/Silo.disabled = false
	$Enemies.target = TownPosition
	$Enemies.set_rate()
