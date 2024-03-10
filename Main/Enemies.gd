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


func _ready():
	if !self.enabled:
		queue_free()


func _physics_process(_delta):
	if randi_range(0, 100) < rate:
		enemy_node = enemy_scene.instantiate()
		enemy_node.position = ((Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()) * spawnDist) + target
		enemy_node.Target = target
		self.add_child(enemy_node)


func set_rate():
	rate = spawnRate


func get_nearest_enemy(pos):
	if self.get_child_count() != 0:
		
		var nearest = self.get_child(0)
		
		for child in self.get_children():
			if child.position.distance_to(pos) < nearest.position.distance_to(pos) and !child.onTarget:
				nearest = child
				
		if !nearest.onTarget:
			nearest.onTarget = true 
			return nearest
		
	
	return null

