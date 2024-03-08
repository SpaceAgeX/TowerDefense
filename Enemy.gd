extends CharacterBody2D


const SPEED = 50.0

var health = 10.0
var damage = 0

var type = 0

@export var Target = Vector2.ZERO

func  _ready():
	type = randi_range(0, 5)
	
	if type > 4 and type < 8:
		$Sprite2D.position.y -= 20
		$Shadow.visible = true
	
	$Sprite2D.frame = type


func _physics_process(delta):
	var direction = position.direction_to(Target)
	
	$Sprite2D.flip_h = direction.x < 0
	
	if direction and position.distance_to(Target) > 150:
		velocity = direction * SPEED
	else:
		queue_free()
		velocity = Vector2.ZERO
	
	move_and_slide()
