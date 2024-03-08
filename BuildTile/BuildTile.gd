extends Node2D

signal clicked(name: Node2D)
signal missileFired(name: Node2D,time)

enum Types {
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var placeable = true
var InArea = false

var health = 10
var damage = 0
var interval = 0
var Cooldown = 0

@export var type:Types = Types.EMPTY

@onready var Building = $Buildings

func _ready():
	updateType()


func _physics_process(delta):
	if Input.is_action_just_pressed("Click") and InArea:
		print("Click on:"+str(position))
		clicked.emit(self.name)	
	match type:
		Types.EMPTY:
			pass
		Types.TOWN:
			pass
		Types.FACTORY:
			pass
		Types.SILO:
			pass
		
		


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
			silo()

func silo():
	$Timer.start()
	interval = 0.1
	Cooldown = 0.1 +interval#Placeholer

	$Timer.wait_time = Cooldown
	missileFired.emit(self.name, interval)
	await $Timer.timeout
	silo()
	
func _on_area_2d_mouse_entered():
	InArea = true


func _on_area_2d_mouse_exited():
	InArea = false
