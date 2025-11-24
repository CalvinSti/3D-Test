extends RigidBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var player_car = VehicleManager.vehicle_instance
var speed  = 100

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	continuous_cd = true
	var random = randf_range(1 , 20)
	global_position = player_car.global_position + Vector3(randf_range(-random, random), 0, randf_range(-random, random))
	global_position.y += 5
	add_to_group("projectile")
	mesh.rotate_y(deg_to_rad(90))

	

func _physics_process(delta: float) -> void:
	var closest_enemy = null
	var closest_dist = INF

	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.is_in_group("ded"):
			continue
		if EnemyCount.enemies <= 0 or player_car.ability_active == true:
			queue_free()
		
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = enemy
			var direction = (closest_enemy.global_position - global_position).normalized()
			linear_velocity = direction * speed
			look_at(global_position + direction, Vector3.UP)

		
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		queue_free()
		return
