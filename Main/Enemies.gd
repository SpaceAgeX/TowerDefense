extends Node2D


var scene = preload("res://Enemy.tscn")
var n = null
@export var enabled = true

@export var spawnDist = 1000

@export var rate = 1 # over 100 chance per frame
@export var rateIncrease = 0 #per frame
func _ready():
	if !enabled:
		queue_free()
func _physics_process(delta):
	
	if randi_range(0, 100) < rate:
		n = scene.instantiate()
		n.position = (Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()) * spawnDist
		add_child(n)
		

