extends Node2D

signal clicked(name:Node2D)


enum Types{
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
	
}

var placeable = true
var InArea = false

@export var type:Types = Types.EMPTY

@onready var Building = $Buildings

func _ready():
	updateType()


func _physics_process(delta):
	if Input.is_action_just_pressed("Click") and InArea:
		print("Click on:"+str(position))
		clicked.emit(self.name)
		
		


func updateType():
	match type:
		Types.EMPTY:
			Building.visible = false
		Types.TOWN:
			Building.visible = true
			Building.frame = 0
			placeable = false
		Types.FACTORY:
			Building.visible = true
			Building.frame = 3
			placeable = false
		Types.SILO:
			Building.visible = true
			Building.frame = 6
			placeable = false
				
func _on_area_2d_mouse_entered():
	InArea = true


func _on_area_2d_mouse_exited():
	InArea = false
