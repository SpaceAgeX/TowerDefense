extends Node2D


var enemy_scene = preload("res://Enemy.tscn")
var enemy_node = null

@export var enabled = true
@export var spawnDist = 1000
@export var rate = 1 # over 100 chance per frame
@export var rateIncrease = 0 #per frame


func _ready():
	if !self.enabled:
		queue_free()


func _physics_process(delta):
	if randi_range(0, 100) < rate:
		enemy_node = enemy_scene.instantiate()
		enemy_node.position = (Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()) * spawnDist
		self.add_child(enemy_node)
		

