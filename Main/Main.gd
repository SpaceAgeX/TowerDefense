extends Node2D

enum Buttons{
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var on = Buttons.EMPTY

func _ready():
	await get_tree().create_timer(0.1).timeout
	for x in $Buildings.get_children():
		x.clicked.connect(on_clicked)
		
		

func on_clicked(name):
	print(name)
	print(on)
	match on:
		Buttons.EMPTY:
			get_node("Buildings/"+str(name)).type = get_node("Buildings/"+str(name)).Types.EMPTY
			on = Buttons.EMPTY
		Buttons.TOWN:
			get_node("Buildings/"+str(name)).type = get_node("Buildings/"+str(name)).Types.TOWN
			on = Buttons.EMPTY
		Buttons.FACTORY:
			get_node("Buildings/"+str(name)).type = get_node("Buildings/"+str(name)).Types.FACTORY
			on =Buttons.EMPTY
		Buttons.SILO:
			get_node("Buildings/"+str(name)).type = get_node("Buildings/"+str(name)).Types.SILO
			on = Buttons.EMPTY
	get_node("Buildings/"+str(name)).updateType()




func _on_town_pressed():
	on = Buttons.TOWN


func _on_factory_pressed():
	on = Buttons.FACTORY


func _on_silo_pressed():
	on = Buttons.SILO
