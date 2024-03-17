extends Node2D

var enemy_scene = preload("res://Enemy/Enemy.tscn")

var rate = -1 # to disable spawning till needed

@export var enabled = true
@export var rateIncrease = 0.01 #per frame
@export var spawnRate = 1 # over 100 chance per frame
@export var x_variation = 750
@export var y_variation = 0

@onready var Buildings = $"../Buildings"
@onready var Enemies = $"../Enemies"
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
	var rand_x_direction = randf_range(-1, 1)
	var rand_y_direction = randf_range(-1, 1)
	
	var enemy_node = enemy_scene.instantiate()
	enemy_node.position.x = self.position.x + (rand_x_direction * x_variation)
	enemy_node.position.y = self.position.y + (rand_y_direction * y_variation)
	enemy_node.killed.connect(Main.on_enemy_killed)
	
	Enemies.add_child(enemy_node)


func get_nearest_enemy(pos):
	if Enemies.get_child_count() != 0:
		var nearest = Enemies.get_child(0)
		
		for child in Enemies.get_children():
			if child.position.distance_to(pos) < nearest.position.distance_to(pos):
				nearest = child
		
		return nearest
	
	return null


func get_nearest_untargeted_enemy(pos):
	if Enemies.get_child_count() != 0:
		
		var nearest = Enemies.get_child(0)
		
		for child in Enemies.get_children():
			if child.position.distance_to(pos) < nearest.position.distance_to(pos) and !child.onTarget:
				nearest = child
				
		if !nearest.onTarget:
			nearest.onTarget = true 
			return nearest
		
	
	return null

