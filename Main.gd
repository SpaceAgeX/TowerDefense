extends Node2D

func _ready():
	await get_tree().create_timer(0.1).timeout
	for x in $Buildings.get_children():
		x.clicked.connect(on_clicked)
		
		

func on_clicked(name):
	print(name)
	name.type = 2
