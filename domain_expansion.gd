extends Node3D

var Car = Global.Car

var e = false
var a = false

func _ready() -> void:
	global_position = Vector3(Car.global_position.x, -10, global_position.z)
	visible = false
	start()

func start():
	Car.global_position.y = Car.global_position.y + 5
	visible = true
	e = true
	
	
func _process(delta: float) -> void:
	if not Global.Car.wheel_collided:
		translate(Vector3(0, 0.1, 0))
	if Global.Car.wheel_collided:
		e = false
		a = true
	if a:
		Global.Car.translate(Vector3(0, 0.3, 0))
		await get_tree().create_timer(0.5).timeout
		a = false
	
	if Global.Car.ability_active:
		Car.add_to_group("Infinity")
		Car.gravity_scale = 0
		await get_tree().create_timer(13).timeout
		Car.remove_from_group("Infinity")
		Car.ability_active = false
	else:
		Car.gravity_scale = 4
