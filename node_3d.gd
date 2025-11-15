extends RigidBody3D

var player = Car
var hp = 100
var speed := 25
var collided = false
var dead = false
var repelled = false
var just_repelled = false
var already_dead = false
var damage_taken = false

@onready var timer = $Timer
@onready var mesh = $MeshInstance3D
@onready var collision = $CollisionShape3D

@export var repel_range := 10.0
@export var repel_strength := 100.0

func _ready() -> void:
	mesh.material_override = mesh.get_active_material(0).duplicate()
	fatass()
	add_to_group("enemies")
	EnemyCount.enemies += 1
	
func _physics_process(delta: float) -> void:
	var direction = position.direction_to(player.global_position).normalized() 
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
		
		for body in get_tree().get_nodes_in_group("Infinity"):
			var dir = position - body.global_position
			var distance = dir.length()
			if distance < repel_range:
				linear_velocity *= 0.999
				angular_velocity *= 0.99
				gravity_scale = 0
				linear_damp = 3
				angular_damp = 0.5
				just_repelled = true
				repelled = true
			else:
				repelled = false
				gravity_scale = 6
				linear_damp = 0
				angular_damp = 0
				
		if repelled:
			return
		elif not repelled and just_repelled:
			await get_tree().create_timer(0.5).timeout
			just_repelled = false
		else:
			velocity.x = horizontal.x
			velocity.z = horizontal.z
			linear_velocity = velocity

	if dead and not already_dead:
		already_dead = true
		timer.stop()
		gravity_scale = 6
		linear_damp = 0
		angular_damp = 0
		mesh.get_active_material(0).albedo_color = Color(1, 0, 0)
		add_to_group("ded")
		await get_tree().create_timer(2).timeout
		EnemyCount.enemies -= 1
		EnemyCount.kills += 1
		queue_free()
		pass
		
	if global_position.y <= -50:
		queue_free()
	
func _on_body_entered(_body: Node) -> void:
	if _body == player and not damage_taken:
		damage_taken = true
		var damage = abs(player.linear_velocity.length())
		print(damage)
		timer.stop()
		hp = hp - damage
		linear_velocity = - position.direction_to(player.global_position).normalized() * 5
		await get_tree().create_timer(0.5).timeout
		damage_taken = false
		if damage > hp / 2 and not dead:
			var knockback_dir = - position.direction_to(player.global_position).normalized()
			var impulse = (knockback_dir + Vector3.UP * abs(player.linear_velocity.length()) ).normalized() * 25
			apply_central_impulse(impulse * mass)
			mesh.get_active_material(0).albedo_color = Color(0.879, 0.338, 0.0, 1.0)
			collided = true
			timer.stop()
		
	if _body.is_in_group("projectile"):
		var damage = abs(_body.linear_velocity.length())
		hp = hp - damage
		
	if _body.is_in_group("Purple"):
		hp = hp - hp
func fatass() -> void:
	continuous_cd = true
	var random = randf_range(1.5, 15.5)
	var range = 300
	mesh.scale = Vector3(random, random, random)
	collision.scale = Vector3(random, random, random)
	hp = random * random
	var base_speed = 300.0
	speed = base_speed / sqrt(hp)
	mass = hp / 1.5
	#print(" speed: ", speed , " mass: ", mass, " hp: ", hp, " gravity: ", gravity_scale)
	var random_pos = Car.global_position + Vector3(randf_range(-range, range), mesh.scale.x, randf_range(-range, range))
	global_position = random_pos
	
func _on_timer_timeout() -> void:
	collided = false
	
