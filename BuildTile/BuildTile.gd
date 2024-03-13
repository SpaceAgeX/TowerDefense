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

var stats = {} # Available Properties/Stats of the Building
var nearest_enemy = null
var timerFinished = false


@export var type: Types = Types.EMPTY:
	set = updateType

@onready var Main = get_tree().get_current_scene()
@onready var Buildings = $Buildings
@onready var Enemies = $"../../Enemies"


func _ready():
	updateType(self.type) # Might Be Redundant - Possibly Remove Later


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
			if timerFinished:
				nearest_enemy = Enemies.get_nearest_untargeted_enemy(self.position)
				print("Finished")
				if nearest_enemy != null:
					updateSilo()
			$ProgressBar.value = 100-($Timer.time_left/$Timer.wait_time)*100


func updateType(new_type: Types):
	type = new_type
	
	match new_type:
		Types.EMPTY:
			Buildings.visible = false
			stats = {}
		
		Types.TOWN:
			setBuilding(0)
			
			stats = { "health": 10, "maxHealth": 10 }
		
		Types.FACTORY:
			setBuilding(3)
			
			stats = { 
				"health": 10, 
				"maxHealth": 10, 
				"productionRate": 5 
			}
		
		Types.SILO:
			setBuilding(6)
			
			stats = { 
				"health": 10, 
				"maxHealth": 10, 
				"damage": 10, 
				"cooldown": 3, 
				"missileTime": 1.0 
			}
			
			$ProgressBar.visible = true
			$Timer.wait_time = self.stats["cooldown"] + self.stats["missileTime"]
			$Timer.start()


func setBuilding(frame):
	Buildings.visible = true
	Buildings.frame = frame
	placeable = false


func updateSilo():
	timerFinished = false
	
	nearest_enemy.onTarget = true
	nearest_enemy.take_damage(self.stats["damage"], self.stats["missileTime"])
	
	var n = missile.instantiate()
	n.target = nearest_enemy
	n.time = self.stats["missileTime"]
	add_child(n)
	
	$Timer.start()


# Only Applicable to Silos
func setRates(cool,time):
	if self.type == BuildTile.Types.SILO:
		if !$Timer.is_stopped():
			if $Timer.wait_time > cool:
				$Timer.stop()
				$Timer.wait_time = cool
				$Timer.start()
				
			else :
				print("No Reset")
		
		self.stats["cooldown"] = cool
		self.stats["missileTime"] = time


func _on_area_2d_mouse_entered():
	InArea = true


func _on_area_2d_mouse_exited():
	InArea = false

func _on_timer_timeout():
	timerFinished = true
	$Timer.stop()
