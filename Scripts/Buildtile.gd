class_name BuildTile extends Node2D


signal clicked(name: Node2D)

enum Types {
	EMPTY,
	TOWN,
	FACTORY,
	SILO,
	DESTROY,
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
@onready var Sprite = $Sprite
@onready var Enemies = $"../../Spawner"
@onready var UI = get_tree().get_current_scene().get_node("UI")


func _ready():
	if randi_range(0,5) in range(3,4):
		$Sprite2D.frame = 1
	elif randi_range(0,5) in range(0,3):
		$Sprite2D.frame = 0
	elif randi_range(0,5) == 5:
		$Sprite2D.frame = 2
	$Timer.stop()
	updateType(self.type)


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
				if nearest_enemy != null:
					updateSilo()

			$ProgressBar.value = 100-(($Timer.time_left/$Timer.wait_time)*100)


func updateType(new_type: Types):
	type = new_type
	
	match new_type:
		Types.EMPTY:
			placeable = true
			Sprite.visible = false
			stats = {}
		
		Types.TOWN:
			placeable = false
			setBuilding(0)
			stats = { "health": 10, "maxHealth": 10 }
		
		Types.FACTORY:
			placeable = false
			setBuilding(3)
			
			stats = { 
				"health": 10, 
				"maxHealth": 10, 
				"productionRate": 5 
			}
		
		Types.SILO:
			placeable = false
			setBuilding(6)
			
			stats = { 
				"health": 10, 
				"maxHealth": 10, 
				"damage": 10, 
				"cooldown": 15, 
				"missileTime": 1.0 
			}
			
			$ProgressBar.visible = true
			$Timer.wait_time = self.stats["cooldown"] + self.stats["missileTime"]
			$Timer.start()
		
		Types.DESTROY:
			stats = {  }
			placeable = false
			$Sprite.frame_coords = Vector2($Sprite.frame_coords.x,1)
			set_ablaze(5)



func setBuilding(frame):
	Sprite.visible = true
	Sprite.frame = frame
	placeable = false


func updateSilo():
	timerFinished = false
	
	$Timer.wait_time = self.stats["cooldown"] + self.stats["missileTime"]
	
	nearest_enemy.onTarget = true
	nearest_enemy.take_damage(self.stats["damage"], self.stats["missileTime"])
	
	var m = missile.instantiate()
	m.target = nearest_enemy
	m.time = self.stats["missileTime"]
	add_child(m)
	
	$Timer.start()


# Only Applicable to Silos
func setRates(cool,time):
	if self.type == BuildTile.Types.SILO:
		$Timer.wait_time = ($Timer.time_left/$Timer.wait_time)*cool
		$Timer.start()
		
		self.stats["cooldown"] = cool
		self.stats["missileTime"] = time


func take_damage(amount, time):
	await get_tree().create_timer(time).timeout
	
	if self.stats.has("health"):
		var tween = create_tween()
		
		self.stats["health"] -= amount
		
		if self.stats["health"] <= 0:
			die()

		tween.tween_property(Sprite, "modulate", Color.from_hsv(0, 1, 1), 0.5)
		#await get_tree().create_timer(0.55)
		tween.tween_property(Sprite, "modulate", Color(0xffffff), 0.5)


func die():
	if type == BuildTile.Types.FACTORY:
		Main.production -= self.stats["productionRate"]
		
		UI.updateCurrency(Main.production, Main.enemy_parts)
		Main.updateTiles()
	
	elif type == BuildTile.Types.TOWN:
		Main.resetGame()
	
	elif type == BuildTile.Types.DESTROY:
		updateType(BuildTile.Types.EMPTY)
		return
	
	updateType(BuildTile.Types.DESTROY)
	$ProgressBar.visible = false


func set_ablaze(time):
	$Fire.visible = true
	await get_tree().create_timer(time).timeout
	$Fire.visible = false


func is_empty() -> bool:
	return self.type == BuildTile.Types.EMPTY


func _on_area_2d_mouse_entered():
	InArea = true


func _on_area_2d_mouse_exited():
	InArea = false

func _on_timer_timeout():
	timerFinished = true
	$Timer.stop()
