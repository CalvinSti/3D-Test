extends Node3D

var Car = Global.Car
#var wheels = Global.Car.Wheels

var e = false
var a = false
var b = false
@onready var area_3d: StaticBody3D = $Area3D
@onready var slashes: GPUParticles3D = $slashes

func _ready() -> void:
	global_position = Vector3(Car.global_position.x, -10, Car.global_position.z)
	visible = false
	slashes.visible = false
	start()

func start():
	area_3d.scale = Vector3(1,1,1)
	visible = true
	e = true
	b = false
	
	
func _process(delta: float) -> void:
	if not Global.Car.wheel_collided:
		#translate(Vector3(0, 0.5, 0))
		global_position = global_position.lerp(Vector3(Car.global_position.x, 30, Car.global_position.z), delta * 0.3)
		area_3d.scale = Vector3(1,1,1)
	if Global.Car.wheel_collided and e:
		e = false
		b = false
		a = true
	if a and Global.Car.wheel_collided:
		Car.global_position = Car.global_position.lerp(Vector3(Car.global_position.x, 35,Car.global_position.z), delta * 0.3)
		await get_tree().create_timer(0.5).timeout
		Car.global_position = Car.global_position.lerp(Vector3(Car.global_position.x, 20, Car.global_position.z), delta * 1)
		await get_tree().create_timer(0.4).timeout
		Car.global_position = Car.global_position.lerp(Vector3(Car.global_position.x, 35,Car.global_position.z), delta * 0.005)
		await get_tree().create_timer(1.5).timeout
		a = false
		b = true
	if b:
		slashes.visible = true
		area_3d.scale = area_3d.scale.lerp(Vector3(50, 50, 50), delta * 10)
		Car.Domain_active = true
		
	if Global.Car.ability_active:
		Car.axis_lock_angular_x = true
		Car.axis_lock_linear_x = true
		Car.axis_lock_angular_y = true
		Car.axis_lock_angular_z = true
		await get_tree().create_timer(15).timeout
		b = false
		Car.Domain_active = false
		Car.ability_active = false
		Car.axis_lock_angular_y = false
		Car.axis_lock_angular_z = true
		Car.gravity_scale = 3
		slashes.visible = false
		area_3d.scale = Vector3(1,1,1)
		Car.axis_lock_angular_x = false
		Car.axis_lock_linear_x = false
		queue_free()
