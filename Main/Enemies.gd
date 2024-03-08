extends Node2D



var enemy_scene = preload("res://Enemy.tscn")
var enemy_node = null

@export var target = Vector2.ZERO
@export var rateIncrease = 0 #per frame
@export var spawnRate = 1 # over 100 chance per frame

var rate = -1 # to disable spawing till needed
var n = null

func _ready():
	if !self.enabled:
		queue_free()

func _physics_process(delta):
	if randi_range(0, 100) < rate:

		enemy_node = enemy_scene.instantiate()
		enemy_node.position = (Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()) * spawnDist
    enemy_node.Target = target
		self.add_child(enemy_node)
		

func set_rate():
	rate = spawnRate


