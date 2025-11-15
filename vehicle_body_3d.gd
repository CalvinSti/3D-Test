extends VehicleBody3D

@export var power := 100
@export var steer := 0.5
@export var sensitivity := 0.0009
@export var projectile: PackedScene
@export var ability: PackedScene

@onready var timer = $Timer
@onready var camera = $Twist/Pivot/Camera3D

@export var blue: PackedScene
@export var red: PackedScene
@export var purple: PackedScene


var twist_pivot := 0.0
var vertical_pivot := 0.0
var ragdoll = false
var player_hp := 100.0
var ability_active = false

@export var projectile_count = 1

func _ready() -> void:
	add_to_group("Player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	timer.start(2)

func _physics_process(delta: float) -> void:
	if not ability_active:
		steering = - move_toward(steering, Input.get_axis("Left", "Right") * steer, delta + 10)
		engine_force = Input.get_axis("Back", "Forward") * power
		
	$Twist.rotate_y(twist_pivot)
	$Twist/Pivot.global_rotation.z += vertical_pivot

	twist_pivot = 0.0
	vertical_pivot = 0.0
	$Twist/Pivot.rotation_degrees.z = clamp($Twist/Pivot.rotation_degrees.z, -40, 25)
	$Twist/Pivot.rotation_degrees.x = clamp($Twist/Pivot.rotation_degrees.x, 0, 0)
	
	#if EnemyCount.kills > 30:
		#add_to_group("Infinity")

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
	
	if Input.is_action_just_pressed("Ability") and not ability_active:
		ability_active = true
		add_to_group("Infinity")
		var purple = ability.instantiate()
		add_child(purple)
		await get_tree().create_timer(15).timeout
		remove_from_group("Infinity")
		ability_active = false
		
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
			var instance = projectile.instantiate()
			add_sibling(instance)
			timer.start(1.5)
	
