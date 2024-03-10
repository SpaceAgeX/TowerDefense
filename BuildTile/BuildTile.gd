class_name BuildTile extends Node2D


signal clicked(name: Node2D)

var missile = preload("res://BuildTile/Missile/Missile.tscn")
var n 

var status = 0 #The Value Given to the UI

enum Types {
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var placeable = true
var InArea = false


#General
var max_health = 10
var health = max_health

#For Silos
var damage = 0
var cooldown = 3
var missileTime = 1.0

#For Factories
var productionRate = 5


@export var type: Types = Types.EMPTY

@onready var Buildings = $Buildings
@onready var Enemies = $"../../Enemies"


func _ready():
	updateType()


func _physics_process(_delta):
	if Input.is_action_just_pressed("Click") and InArea:
		#print("Click on:" + str(position))
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
			Buildings.visible = false
		
		Types.TOWN:
			Buildings.visible = true
			Buildings.frame = 0
			placeable = false
		
		Types.FACTORY:
			Buildings.visible = true
			Buildings.frame = 3
			placeable = false
		
		Types.SILO:
			Buildings.visible = true
			Buildings.frame = 6
			placeable = false
			updateSilo()


func updateSilo():
	$Timer.wait_time = cooldown + missileTime
	$Timer.start()
	await $Timer.timeout
	var nearest_enemy = Enemies.get_nearest_enemy(self.position)
	
	if nearest_enemy != null:
		nearest_enemy.targeted(missileTime)
		
		n = missile.instantiate()
		n.target = nearest_enemy
		n.time = missileTime
		add_child(n)
	
	updateSilo()


func _on_area_2d_mouse_entered():
	InArea = true
func _on_area_2d_mouse_exited():
	InArea = false


func getRates(cool,missile):
	cooldown = cool
	missileTime = missile
	print(cool)
