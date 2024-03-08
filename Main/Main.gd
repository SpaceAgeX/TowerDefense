extends Node2D

enum Buttons{
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var on = Buttons.EMPTY



var Building
@onready var Display = $UI/HUD/Display

func _ready():
	await get_tree().create_timer(0.1).timeout
	for x in $Buildings.get_children():
		x.clicked.connect(on_clicked)
		
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
		print(tile)
		print(on)
		match on:
			Buttons.EMPTY:
				Building.type = Building.Types.EMPTY
				on = Buttons.EMPTY
				
			Buttons.TOWN:
				Building.type = Building.Types.TOWN
				on = Buttons.EMPTY
			Buttons.FACTORY:
				Building.type = Building.Types.FACTORY
				on =Buttons.EMPTY
			Buttons.SILO:
				Building.type = Building.Types.SILO
				on = Buttons.EMPTY
		$UI/Buttons.visible = true
	else:
		$UI/HUD/Display.write("Can't Place There", 3)
	
	
	get_node("Buildings/"+str(tile)).updateType()




func _on_town_pressed():
	$UI/Buttons.visible = false
	on = Buttons.TOWN


func _on_factory_pressed():
	$UI/Buttons.visible = false
	on = Buttons.FACTORY


func _on_silo_pressed():
	$UI/Buttons.visible = false
	on = Buttons.SILO
