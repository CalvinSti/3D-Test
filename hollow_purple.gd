extends Node3D

@onready var Purple: Node3D = $Node3D3
@onready var Red: Node3D = $Node3D2
@onready var Blue: Node3D = $Node3D
@onready var explosion = $Area3D/CollisionShape3D.shape

@onready var Gojo_yap = $AudioStreamPlayer2D
@onready var timer = $Timer

var e = false
var scaling = false

func _ready() -> void:
	Blue.visible = false
	Red.visible = false
	Purple.visible = false
	Start()

		
func Start():
	Gojo_yap.play()
	await get_tree().create_timer(2.6).timeout
	Blue.visible = true
	Red.visible = true

	Blue.global_position = Car.global_position - Car.global_transform.basis.z.normalized() * 10 + Vector3(0,5,0)
	Red.global_position = Car.global_position + Car.global_transform.basis.z.normalized() * 10 + Vector3(0,5,0)
	
	await get_tree().create_timer(4).timeout
	e = true
	
var angle := 0.0
var orbit_speed := 13.5
var shrink_speed := 13.5

func _process(delta: float) -> void:
	if e:
		#Blue.translate(Vector3(0, 0, 0.1))
		#Red.translate(Vector3(0, 0, -0.1))
		
		Car.translate(Vector3(0, 0.35, 0))
		
		var start_distance = Blue.global_position.distance_to(Red.global_position)
		var center = (Blue.global_position + Red.global_position) / 2
		var initial_distance = max(0.0, start_distance - shrink_speed * delta)
		var radius = initial_distance / 2
		
		angle += orbit_speed * delta
		Blue.global_position = center + Vector3(cos(angle) * radius, 0.1, sin(angle) * radius)
		Red.global_position = center + Vector3(cos(angle + PI) * radius, 0.1, sin(angle + PI) * radius)
		
		
		var distance = Blue.global_position.distance_to(Red.global_position)
		if distance <= 0.001:
			e = false
			Red.visible = false
			Blue.visible = false
			Purple.visible = true
			Purple.global_position = Blue.global_position
			scaling = true
			await get_tree().create_timer(2).timeout
			for i in range(10):
				scale *= Vector3(5, 5, 5)
				explosion.radius *= 1000
				await get_tree().create_timer(0.001).timeout
			await get_tree().create_timer(0.5).timeout
			scale = Vector3(1, 1, 1)
			explosion.radius = 1
			Purple.visible = false
			await get_tree().create_timer(5).timeout
			queue_free()

	if scaling:
		Purple.scale = Purple.scale.lerp(Vector3(10, 10, 10), delta * 0.3)
		await get_tree().create_timer(2).timeout
		scaling = false
