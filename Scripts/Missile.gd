class_name MissileLauncher extends CharacterBody2D

@onready var Enemies = get_tree().get_current_scene().get_node("Spawner")

var target: Node2D
var time: float

var speed: float
var dist: float

var dir
var t = 0


func _ready():
	$Timer.wait_time = time
	$Timer.start()
	speed = global_position.distance_to(target.global_position) / time
	dist = global_position.distance_to(target.global_position)


func _physics_process(delta):
	t += delta

	if target != null:
		$Sprite2D.visible = true
		$Sprite2D.global_position = global_position.lerp(target.global_position, t)
		look_at(target.position)
	else:
		$Sprite2D.visible = false
		queue_free()


func _on_timer_timeout():
	queue_free()
