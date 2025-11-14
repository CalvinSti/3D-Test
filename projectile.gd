extends RigidBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D

var speed  = 60

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	continuous_cd = true
	var random = randf_range(1 , 20)
	global_position = Car.global_position + Vector3(randf_range(-random, random), 0, randf_range(-random, random))
	global_position.y += 5
	print(random)
	add_to_group("projectile")
	

func _physics_process(delta: float) -> void:
	var closest_enemy = null
	var closest_dist = INF

	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.is_in_group("ded"):
			continue
			
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = enemy
			var direction = (closest_enemy.global_position - global_position).normalized()
			linear_velocity = direction * speed
			
		
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		queue_free()
		return
