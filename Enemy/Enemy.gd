extends CharacterBody2D


signal killed

var SPEED = randi_range(25,100)

var onTarget = false
var health = 10.0
var damage = 1
var hit_range = 300
var hit_cooldown = 2
var type = 0

@export var Target: Vector2

@onready var Buildings = $"../../Buildings"
@onready var Main = get_tree().get_current_scene()

func  _ready():
	type = randi_range(0, 5)
	
	if type > 4 and type < 8:
		$Sprite2D.position.y -= 20
		$Shadow.visible = true
		$Target.position.y -= 20
	
	$Sprite2D.frame = type
	
	damage_close_buildings()


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
		killed.emit()
		self.queue_free()
	
	$Target.visible = false
	onTarget = false


func damage_close_buildings():
	print("Damaging Close Buildings")
	
	#for building in Buildings.get_children():
	#	if building.position.distance_to(self.position) <= self.hit_range:
	#		building.take_damage(self.damage)
	
	var target_building = Buildings.get_nearest_building(self.position)
	
	if target_building.position.distance_to(self.position) < self.hit_range:
		target_building.take_damage(self.damage)
	
	$Timer.wait_time = self.hit_cooldown
	$Timer.start()


func _on_timer_timeout():
	damage_close_buildings()
