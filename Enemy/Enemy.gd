extends CharacterBody2D


signal killed(enemy: CharacterBody2D)


var SPEED = randi_range(25,100)

var onTarget = false
var health = 10.0
var damage = 0
var type = 0

@export var Target = Vector2.ZERO
@onready var Main = get_tree().get_current_scene()

func  _ready():
	
	type = randi_range(0, 5)
	
	if type > 4 and type < 8:
		$Sprite2D.position.y -= 20
		$Shadow.visible = true
		$Target.position.y -= 20
	
	$Sprite2D.frame = type


func _physics_process(_delta):
	var direction = position.direction_to(Target)
	
	$Sprite2D.flip_h = direction.x < 0
	
	if direction and position.distance_to(Target) > 150:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	
	
	
func take_damage(dmg, time):
	$Target.visible = true
	await get_tree().create_timer(time).timeout

	health -= dmg
  
  if health <= 0:
		Main.enemy_parts += 1
		killed.emit(self)
		self.queue_free()
    
	onTarget = false

