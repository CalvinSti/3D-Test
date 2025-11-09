extends RigidBody3D

var player = Car
var hp = 100
var speed := 25
var collided = false
var dead = false
@onready var timer = $Timer
@onready var mesh = $MeshInstance3D
@onready var collision = $CollisionShape3D

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	mesh.material_override = mesh.get_active_material(0).duplicate()
	continuous_cd = true
	fatass()
	
func _physics_process(delta: float) -> void:
	var direction = position.direction_to(Car.global_position + Vector3(0, 15, 0)).normalized() 
	if collided and hp > 0:
		if timer.is_stopped():
			timer.start(3.0)
	elif hp <= 0:
		timer.stop()
		dead = true
	else:
		timer.stop()
		var velocity = linear_velocity
		var horizontal = Vector3(direction.x, 0, direction.z) * speed
		mesh.get_active_material(0).albedo_color = Color(1.0, 1.0, 1.0, 1.0)
		velocity.x = horizontal.x
		velocity.z = horizontal.z
		linear_velocity = velocity
		
	#print(collided,"  ", angular_velocity.length(), "  ", linear_velocity.length())
	#print(timer.time_left)
	
func _on_body_entered(_body: Node) -> void:
	if _body == player:
		var damage = abs(player.linear_velocity.length())
		timer.stop()
		hp = hp - damage
		linear_velocity = - position.direction_to(Car.global_position).normalized() * abs(player.linear_velocity.length()) 
		if damage > hp / 2:
			var knockback_dir = - position.direction_to(Car.global_position).normalized()
			var impulse = (knockback_dir + Vector3.UP * abs(player.linear_velocity.length()) ).normalized() * abs(player.linear_velocity.length())
			apply_central_impulse(impulse * mass)
			mesh.get_active_material(0).albedo_color = Color(0.879, 0.338, 0.0, 1.0)
			collided = true
		if dead:
			timer.stop()
			mesh.get_active_material(0).albedo_color = Color(1, 0, 0)
			await get_tree().create_timer(3.0).timeout
			EnemyCount.enemies = EnemyCount.enemies - 1
			print(EnemyCount.enemies)
			queue_free()
			return

func fatass() -> void:
	continuous_cd = true
	var random = randf_range(1.0, 25.0)
	var range = 300
	mesh.scale = Vector3(random, random, random)
	collision.scale = Vector3(random, random, random)
	hp = random * random
	var base_speed = 300.0
	speed = base_speed / sqrt(hp) - 5
	mass = hp / 2.5
	linear_damp = mesh.scale.x + collision.scale.x / (2 + mass + hp)
	#print("damp: ",linear_damp , " speed: ", speed , " mass: ", mass, " hp: ", hp, " gravity: ", gravity_scale)
	var random_pos = Vector3(randf_range(-range, range), mesh.scale.x, randf_range(-range, range))
	global_position = random_pos
	
	timer.start(random * random - random)
	
	
func _on_timer_timeout() -> void:
	collided = false
