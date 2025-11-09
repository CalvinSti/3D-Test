extends VehicleBody3D

@export var power := 100
@export var steer := 0.5
@export var sensitivity := 0.0009
@export var projectile: PackedScene

@onready var timer = $Timer
@onready var camera = $Twist/Pivot/Camera3D


var twist_pivot := 0.0
var vertical_pivot := 0.0
var ragdoll = false
var player_hp := 100.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	steering = - move_toward(steering, Input.get_axis("Left", "Right") * steer, delta + 10)
	engine_force = Input.get_axis("Back", "Forward") * power
		
	$Twist.rotate_y(twist_pivot)
	$Twist/Pivot.global_rotation.z += vertical_pivot

	twist_pivot = 0.0
	vertical_pivot = 0.0
	$Twist/Pivot.rotation_degrees.z = clamp($Twist/Pivot.rotation_degrees.z, -40, 25)
	$Twist/Pivot.rotation_degrees.x = clamp($Twist/Pivot.rotation_degrees.x, 0, 0)


	if Input.is_action_just_pressed("R"):
		rotation.z = 0
		global_position = Vector3.ZERO
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("Forward"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var speed = linear_velocity
	
	timer.start(5.0)
	print(timer.time_left)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_pivot = -  event.relative.x * sensitivity
			vertical_pivot = - event.relative.y * sensitivity


func _on_timer_timeout() -> void:
	print("aaaaaaaaaaaaaaa")
	var instance = projectile.instantiate()
	add_child(instance)
