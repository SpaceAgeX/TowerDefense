extends Node2D


var scene = preload("res://Enemy.tscn")

@export var enabled = true

@export var spawnDist = 1000

@export var target = Vector2.ZERO
@export var rateIncrease = 0 #per frame
@export var spawnRate = 1 # over 100 chance per frame

var rate = -1 # to disable spawing till needed
var n = null

func _ready():
	if !enabled:
		queue_free()
		
func _physics_process(delta):
	
	if randi_range(0, 100) < rate:
		n = scene.instantiate()
		n.Target = target
		n.position = (Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()) * spawnDist
		add_child(n)

func set_rate():
	rate = spawnRate

