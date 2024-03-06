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
		
		

func on_clicked(name):
	Building = get_node("Buildings/"+str(name))
	if Building.placeable:
		print(name)
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
	else:
		$UI/HUD/Display.write("Can't Place There Stupid",2)
		
	get_node("Buildings/"+str(name)).updateType()




func _on_town_pressed():
	on = Buttons.TOWN


func _on_factory_pressed():
	on = Buttons.FACTORY


func _on_silo_pressed():
	on = Buttons.SILO
