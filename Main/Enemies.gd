extends Node2D

var enemy_scene = preload("res://Enemy/Enemy.tscn")
var enemy_node = null

var target = Vector2.ZERO
var rate = -1 # to disable spawing till needed
var n = null

@export var enabled = true
@export var rateIncrease = 0 #per frame
@export var spawnRate = 1 # over 100 chance per frame
@export var spawnDist = 1500

@onready var Buildings = $"../Buildings"
@onready var Main = $".."


func _ready():
	if !self.enabled:
		queue_free()


func set_rate():
	rate = spawnRate


func _physics_process(_delta):
	if randf_range(0, 100) < rate:
		spawnEnemy()


func spawnEnemy():
	enemy_node = enemy_scene.instantiate()

	
	var randSpawnDirection = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	#var rand_building = Buildings.get_random_building()
	#var nearest_building = Buildings.get_nearest_building(enemy_node.position)
	
	enemy_node.Target = target
	enemy_node.position = (randSpawnDirection * spawnDist) + enemy_node.Target
	#enemy_node.Target = rand_building.position
	
	enemy_node.killed.connect(Main.on_enemy_killed)
	self.add_child(enemy_node)


func get_nearest_enemy(pos):
	if self.get_child_count() != 0:
		var nearest = self.get_child(0)
		
		for child in self.get_children():
			if child.position.distance_to(pos) < nearest.position.distance_to(pos):
				nearest = child
		
		return nearest
	
	return null


func get_nearest_untargeted_enemy(pos):
	if self.get_child_count() != 0:
		
		var nearest = self.get_child(0)
		
		for child in self.get_children():
			if child.position.distance_to(pos) < nearest.position.distance_to(pos) and !child.onTarget:
				nearest = child
				
		if !nearest.onTarget:
			nearest.onTarget = true 
			return nearest
		
	
	return null

