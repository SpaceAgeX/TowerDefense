extends CharacterBody2D



var target 
var time

var dir 
var speed
var t = 0
var dist
func _ready():
	$Timer.wait_time = time
	$Timer.start()
	speed = global_position.distance_to(target.global_position)/time
	dist = global_position.distance_to(target.global_position)

func _physics_process(delta):
	t += delta
	if target != null:
		$Sprite2D.global_position = global_position.lerp(target.global_position, t)
		look_at(target.position)
	else:
		queue_free()
	


func _on_timer_timeout():
	queue_free()
