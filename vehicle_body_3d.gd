extends VehicleBody3D

@export var power := 100
@export var steer := 0.5
@export var sensitivity := 0.1
@onready var wheels = get_tree().get_nodes_in_group("wheel")

@onready var timer = $Timer
@onready var camera = $Twist/Pivot/Camera3D

const Purple = preload("uid://wx2k6jypw8ka")
const Projectile = preload("uid://crs0jy5cyw5kv")
const Ability = preload("uid://wx2k6jypw8ka")

var twist_pivot := 0.0
var vertical_pivot := 0.0
var ragdoll = false
var player_hp := 100.0
var ability_active = false
var drifting = false

@export var projectile_count = 1

func _ready() -> void:
	add_to_group("Player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	timer.start(2)

func _physics_process(delta: float) -> void:
	if not ability_active:
		steering = - move_toward(steering, Input.get_axis("Left", "Right") * steer, delta + 10)
		engine_force = Input.get_axis("Back", "Forward") * power

	if Input.is_action_just_pressed("R"):
		rotation.z = 0
		linear_velocity = Vector3(0,0,0)
		angular_velocity = Vector3(0, 0 ,0)
		global_position = Vector3.ZERO
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("Forward"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("Brake") or ability_active:
		linear_velocity *= Vector3(0.995, 0, 0.995)
		gravity_scale = 0
	else:
		gravity_scale = 4
	if Input.is_action_pressed("drift"):
		drifting = true
	else: 
		drifting = false
		
	
	if drifting:
		for wheel in wheels:
			wheel.wheel_friction_slip = 3
	else:
		for wheel in wheels:
			wheel.wheel_friction_slip = 10
			
			
	if Input.is_action_just_pressed("Ability") and not ability_active:
		ability_active = true
		add_to_group("Infinity")
		var purple = Ability.instantiate()
		add_child(purple)
		axis_lock_angular_y = true
		axis_lock_angular_x = true
		axis_lock_angular_z = true
		await get_tree().create_timer(12).timeout
		remove_from_group("Infinity")
		axis_lock_angular_y = false
		axis_lock_angular_x = false
		axis_lock_angular_z = false
		ability_active = false
		
	$Twist.rotate_y(twist_pivot * delta)
	$Twist/Pivot.global_rotation.z += vertical_pivot * delta
	twist_pivot = 0.0
	vertical_pivot = 0.0
	$Twist/Pivot.rotation_degrees.z = clamp($Twist/Pivot.rotation_degrees.z, -40, 25)
	$Twist/Pivot.rotation_degrees.x = clamp($Twist/Pivot.rotation_degrees.x, 0, 0)
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_pivot = -  event.relative.x * sensitivity
			vertical_pivot = - event.relative.y * sensitivity

func _on_timer_timeout() -> void:
	if EnemyCount.enemies <= 0 or ability_active:
		pass
	else:
		for i in projectile_count:
			var instance = Projectile.instantiate()
			add_sibling(instance)
			timer.start(1.5)
	
