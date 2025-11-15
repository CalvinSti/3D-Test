extends Node3D

@export var Blue: PackedScene
@export var Red: PackedScene
@export var Purple: PackedScene
@onready var explosion = $Area3D/CollisionShape3D.shape

var BlueB
var RedR
var PurpleP

@onready var Gojo_yap = $AudioStreamPlayer2D
@onready var timer = $Timer

var e = false
var scaling = false

func _ready() -> void:
	Start()
	
func Start():
	BlueB = Blue.instantiate()
	RedR = Red.instantiate()
	PurpleP = Purple.instantiate()
	Gojo_yap.play()
	await get_tree().create_timer(2.6).timeout
	add_child(BlueB)
	add_child(RedR)
	
	BlueB.global_position = Car.global_position - Car.global_transform.basis.z.normalized() * 5 + Vector3(0,7,0)
	RedR.global_position = Car.global_position + Car.global_transform.basis.z.normalized() * 5 + Vector3(0,7,0)
	
	await get_tree().create_timer(4).timeout
	e = true
	
var angle := 0.0
var orbit_speed := 8
var shrink_speed := 9

func _process(delta: float) -> void:
	if e:
		#BlueB.translate(Vector3(0, 0, 0.1))
		#RedR.translate(Vector3(0, 0, -0.1))
		
		var start_distance = BlueB.global_position.distance_to(RedR.global_position)
		var center = (BlueB.global_position + RedR.global_position) / 2
		var initial_distance = max(0.0, start_distance - shrink_speed * delta)
		var radius = initial_distance / 2
		
		angle += orbit_speed * delta
		BlueB.global_position = center + Vector3(cos(angle) * radius, 0.05, sin(angle) * radius)
		RedR.global_position = center + Vector3(cos(angle + PI) * radius, 0.05, sin(angle + PI) * radius)
		
		var height = BlueB.get_global_position().y
		
		var distance = BlueB.global_position.distance_to(RedR.global_position)
		if distance <= 0.001:
			e = false
			BlueB.queue_free()
			RedR.queue_free()
			add_child(PurpleP)
			PurpleP.global_position = Car.global_position + Vector3(0, height, 0)
			scaling = true
			await get_tree().create_timer(3).timeout
			for i in range(10):
				scale *= Vector3(5, 5, 5)
				explosion.radius += 10000
				await get_tree().create_timer(0.001).timeout
			await get_tree().create_timer(0.5).timeout
			scale = Vector3(1, 1, 1)
			explosion.radius = 0
			PurpleP.queue_free()
			await get_tree().create_timer(5).timeout
			queue_free()
			
			
	if scaling:
		PurpleP.scale = PurpleP.scale.lerp(Vector3(10, 10, 10), delta * 0.3)
		await get_tree().create_timer(2).timeout
		scaling = false
