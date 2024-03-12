class_name BuildTile extends Node2D


signal clicked(name: Node2D)

enum Types {
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
}

var missile = preload("res://BuildTile/Missile/Missile.tscn")

var placeable = true
var InArea = false



#General
var max_health = 10
var health = max_health

#For Silos
var damage = 5
var cooldown = 3

var missileTime = 1.0

#For Factories
var productionRate = 5


@export var type: Types = Types.EMPTY

@onready var Main = get_tree().get_current_scene()
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
			$ProgressBar.value = 100-($Timer.time_left/$Timer.wait_time)*100


func updateType():
	match type:
		Types.EMPTY:
			Buildings.visible = false
		
		Types.TOWN:
			setBuilding(0)
		
		Types.FACTORY:
			setBuilding(3)
	
		
		Types.SILO:
			setBuilding(6)
			$ProgressBar.visible = true
			updateSilo()
			
func setBuilding(frame):
	Buildings.visible = true
	Buildings.frame = frame
	placeable = false

func updateSilo():
	$Timer.wait_time = cooldown + missileTime
	$Timer.start()
	await $Timer.timeout
	var nearest_enemy = Enemies.get_nearest_untargeted_enemy(self.position)
	
	if nearest_enemy != null:
		nearest_enemy.onTarget = true
		nearest_enemy.take_damage(self.damage, missileTime)
		
		var n = missile.instantiate()
		n.target = nearest_enemy
		n.time = missileTime
		add_child(n)
	
	updateSilo()





func _on_area_2d_mouse_entered():
	InArea = true
func _on_area_2d_mouse_exited():
	InArea = false


func getRates(cool,time):
	
	if !$Timer.is_stopped():
		$Timer.stop()
		if $Timer.wait_time > cool:
			$Timer.wait_time = cool
			$Timer.start()
			print(cool)
	cooldown = cool
	missileTime = time
