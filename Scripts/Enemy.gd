extends CharacterBody2D


signal killed(enemy)

var SPEED = randi_range(25,100)

enum Behaviors {
	SOLDIER,
	TANK,
	PLANE
}


var missile = preload("res://BuildTile/Missile/Missile.tscn")

var onTarget = false
var health = 10.0
var reward = 40 # The Number of Enemy Parts You Get Upon Death

var bomb_damage = 1
var bomb_range = 200
var has_bombed = false

var explode_damage = 3
var explode_range = 100

var shot_damage = 1
var shot_range = 500
var shot_cooldown = 3

var type = 0

var target_building
var behavior: Behaviors
var direction: Vector2

@onready var Buildings = $"../../Buildings"
@onready var Main = get_tree().get_current_scene()


func  _ready():
	type = randi_range(0, 5)
	
	if type == 0 or type == 1:
		behavior = Behaviors.SOLDIER
		target_building = Buildings.get_nearest_building(self.position)
		shoot_target()
	
	elif type > 1 and type < 5:
		behavior = Behaviors.TANK
		#print(behavior)
		target_building = Buildings.get_nearest_building(self.position)
		shoot_target()
	
	elif type > 4 and type < 8:
		$Sprite2D.position.y -= 20
		$Shadow.visible = true
		$Target.position.y -= 20
		behavior = Behaviors.PLANE
		SPEED = randi_range(160,250)
		target_building = Buildings.get_random_building()
	
	direction = position.direction_to(target_building.global_position)
	$Sprite2D.frame = type


func _physics_process(_delta):
	$Sprite2D.flip_h = direction.x < 0
	$Shadow.flip_h = direction.x < 0
	
	match behavior:
		Behaviors.SOLDIER:
			target_building = Buildings.get_nearest_building(self.position)
			direction = position.direction_to(target_building.global_position)
			
			if direction and position.distance_to(target_building.global_position) > 200:
				velocity = direction * SPEED
			else:
				velocity = Vector2.ZERO
			
			move_and_slide()
		
		Behaviors.TANK:
			target_building = Buildings.get_nearest_building(self.position)
			direction = position.direction_to(target_building.global_position)
			
			velocity = direction * SPEED
			
			if direction and position.distance_to(target_building.global_position) < 5:
				explode()
			
			move_and_slide()
		
		Behaviors.PLANE:
			velocity = direction * SPEED
			move_and_slide()
			
			if position.distance_to(target_building.global_position) < 5 and not has_bombed:
				drop_bomb()
			
			if has_bombed:
				await get_tree().create_timer(10).timeout
				queue_free()


func take_damage(dmg, time):
	$Target.visible = true
	await get_tree().create_timer(time).timeout
	
	health -= dmg
	
	if health <= 0:
		killed.emit(self)
		self.queue_free()
	
	$Target.visible = false
	onTarget = false


func shoot_target():
	if target_building.global_position.distance_to(self.position) < self.shot_range:
		var delay = 1.0
		
		var m = missile.instantiate()
		m.target = target_building
		m.time = delay
		add_child(m)
		
		target_building.take_damage(self.shot_damage, delay)
		pass
	
	$Timer.wait_time = self.shot_cooldown
	$Timer.start()


func drop_bomb():
	var m = missile.instantiate()
	m.target = target_building
	m.time = 1.0
	
	has_bombed = true
	
	await get_tree().create_timer(1.0).timeout
	
	for building in Buildings.get_children():
		if position.distance_to(building.global_position) < bomb_range:
			building.set_ablaze(2.0)
			
			if not building.is_empty():
				building.take_damage(self.bomb_damage, 0.0)



func explode():
	for building in Buildings.get_children():
		if not building.is_empty() and position.distance_to(building.global_position) < explode_range:
			building.take_damage(self.explode_damage, 0.0)
			building.set_ablaze(2.0)
	
	self.visible = false
	queue_free()


func _on_timer_timeout():
	shoot_target()
