class_name BuildTile extends Node2D


signal clicked(name: Node2D)

enum Types {
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var placeable = true
var InArea = false

var max_health = 10
var health = max_health
var cooldown = 1.5

@export var type: Types = Types.EMPTY

@onready var Buildings = $Buildings
@onready var Enemies = $"../../Enemies"


func _ready():
	updateType()


func _physics_process(_delta):
	if Input.is_action_just_pressed("Click") and InArea:
		print("Click on:" + str(position))
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
	await get_tree().create_timer(cooldown + 0.1).timeout
	var nearest_enemy = Enemies.get_nearest_enemy(self.position)
	
	if nearest_enemy != null:
		nearest_enemy.targeted(cooldown)
	
	updateSilo()


func _on_area_2d_mouse_entered():
	InArea = true


func _on_area_2d_mouse_exited():
	InArea = false
