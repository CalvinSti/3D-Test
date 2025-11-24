extends RigidBody3D

var player = Global.Car
var Car = Global.Car
var hp = 100
var speed := 25
var collided = false
var dead = false
var repelled = false
var just_repelled = false
var already_dead = false
var damage_taken = false
var random := 0
var is_teto = false
var eHp

@onready var timer = $Timer
@onready var mesh = $MeshInstance3D
@onready var collision = $CollisionShape3D
@onready var fatass_teto_2 = $"fatass teto2"


@export var repel_range := 10.0
@export var repel_strength := 100.0

func _ready() -> void:
	mesh.material_override = mesh.get_active_material(0).duplicate()
	add_to_group("enemies")
	fatass()
	
func _physics_process(delta: float) -> void:
	if Global.Car.dead:
		return
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
		
		if Car.is_in_group("Infinity"):
			var dir = position - Car.global_position
			var distance = dir.length()
			if distance < repel_range:
				linear_velocity *= 0.999
				angular_velocity *= 0.99
				gravity_scale = 0.05
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
		#elif dead and already_dead:
			#gravity_scale = 6
			#linear_damp = 0
			#angular_damp = 0
			#return
		else:
			velocity.x = horizontal.x
			velocity.z = horizontal.z
			linear_velocity = velocity
		#
		if Car.drifting:
			collision_layer = 0 | 2
			if is_teto:
				collision_layer = 1
		elif Car.ability_active:
			collision_layer = 3 | 1
			collision_mask = 3| 1
		else:
			collision_layer = 1 | 3
	random = randf_range(1, 10)
	
	if dead and not already_dead:
		already_dead = true
		timer.stop()
		gravity_scale = 6
		linear_damp = 0
		angular_damp = 0
		mesh.get_active_material(0).albedo_color = Color(1, 0, 0)
		add_to_group("ded")
		remove_from_group("enemies")
		EnemyCount.enemies -= 1
		EnemyCount.kills += 1
		await get_tree().create_timer(2).timeout
		collision.disabled = true
		visible = false
		await get_tree().create_timer(random * random - random).timeout
		fatass()
		return
		
	if global_position.y <= -50:
		queue_free()
	
func _on_body_entered(_body: Node) -> void:
	if _body == player and not damage_taken:
		damage_taken = true
		var damage = abs(player.linear_velocity.length())
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
		hp = hp - (damage / 2.5)
		
	if _body.is_in_group("Purple"):
		if is_teto:
			return
		else:
			hp = hp - hp

func fatass() -> void:
	if EnemyCount.total_enemies >= EnemyCount.max_enemies:
		queue_free()
		return
	visible = true
	collision.disabled = false
	damage_taken = false
	already_dead = false
	dead = false
	just_repelled = false
	repelled = false
	EnemyCount.enemies += 1
	EnemyCount.total_enemies += 1
	remove_from_group("ded")
	add_to_group("enemies")
	var random = randf_range(1.5, 15.5)
	var range = 300
	mesh.scale = Vector3(random, random, random)
	collision.scale = Vector3(random, random, random)
	fatass_teto_2.scale = mesh.scale / 12
	hp = random * random
	eHp = hp
	var base_speed = 300.0
	var teto_chance = randi_range(1,100)
	if teto_chance >= 100:
		hp = random * random * random
		mass = hp * 6
		fatass_teto_2.visible = true
		mesh.visible = false
		is_teto = true
		speed = base_speed / (sqrt(hp) - 7)
		var Mass = mass
	else:
		hp = random * random
		mass = hp / 1.5
		fatass_teto_2.visible = false
		mesh.visible = true
		is_teto = false
		speed = base_speed / sqrt(hp)
		var Mass = mass
	#print(" speed: ", speed , " mass: ", mass, " hp: ", hp, " gravity: ", gravity_scale)
	var random_pos = Global.Car.global_position + Vector3(randf_range(-range, range), mesh.scale.x, randf_range(-range, range))
	global_position = random_pos
	
func _on_timer_timeout() -> void:
	collided = false
	
