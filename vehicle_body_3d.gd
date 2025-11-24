extends VehicleBody3D

@export var power := 100
@export var steer := 0.7
@export var sensitivity := 0.1
@export var wheels: Array[VehicleWheel3D]
@export var rwheels: Array[VehicleWheel3D]
@export var trails: Array[GPUParticles3D]

@export var curve: Curve
@onready var timer = $Timer
@onready var camera = $Twist/Pivot/Camera3D
@onready var twist = $Twist
@onready var pivot = $Twist/Pivot

@export var Projectile: PackedScene
@export var Ability: PackedScene

@export var Carhp = 100.0

var twist_pivot := 0.0
var vertical_pivot := 0.0
var hit = false
var ability_active = false
var drifting = false
var alreadyturning = false
var dead = false
var no_recoil = false
var menu = false
var Starting_power = power
var wheel_collided = false
@export var projectile_count = 1
@export var friction = 10

func _ready() -> void:
	if get_tree().current_scene.scene_file_path.ends_with("Main-Menu.tscn"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		camera.current = false
	else:
		camera.current = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if menu:
		return
	add_to_group("Player")
	Starting_power = power
	timer.start(2)
	

func _physics_process(delta: float) -> void:
	if menu:
		return
	if not ability_active or not dead:
		engine_force = Input.get_axis("Back", "Forward") * power
		if ability_active:
			pass
		else:
			if drifting:
				steering = move_toward(steering,Input.get_axis("Left", "Right") * steer, delta * 1)
			else:
				steering = move_toward(steering,Input.get_axis("Left", "Right") * steer, delta * 75)

		if Input.get_axis("Left", "Right") and not drifting:
			power = Starting_power
			alreadyturning = true
			no_recoil = false
			if Input.is_action_pressed("drift"):
				power = 1500
		elif Input.get_axis("Left", "Right") and drifting:
			if not alreadyturning:
				power = Starting_power + 1000
				if not hit:
					no_recoil = true
				else:
					no_recoil = false
		else: 
			power = Starting_power
			drifting = false
			alreadyturning = false
			no_recoil = false

	if Input.is_action_just_pressed("R"):
		global_rotation.z = 0
		#global_rotation.x = 160
		linear_velocity = Vector3(0,0,0)
		angular_velocity = Vector3(0, 0 ,0)
		global_position = Vector3(global_position.x, 0, global_position.z)
		visible = true
		Carhp = 100
		if dead:
			dead = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("Brake") or ability_active:
		linear_velocity *= Vector3(0.995, 0, 0.995)

	if Input.is_action_just_pressed("Ability") and not ability_active:
		ability_active = true
		var purple = Ability.instantiate()
		add_child(purple)
		
	
	for wheel in wheels:
		if wheel.is_in_contact() and ability_active:
			wheel_collided = true
	
	twist.rotate_y(twist_pivot * delta)
	pivot.global_rotation.z += vertical_pivot * delta
	twist_pivot = 0.0
	vertical_pivot = 0.0
	pivot.rotation_degrees.z = clamp(pivot.rotation_degrees.z, -40, 25)
	pivot.rotation_degrees.x = clamp(pivot.rotation_degrees.x, 0, 0)
	
	if global_position.y < -100:
		global_position = Vector3(global_position.x, 10, global_position.z)
		Carhp -= 10
	
	if Carhp <= 0:
		visible = false
		dead = true
	if Input.is_action_pressed("drift"):
		drifting = true
	else:
		drifting = false
		
	if drifting:
		for wheel in wheels:
			var slip = abs(steering) 
			slip = clamp(slip, 0.0, 1.0)
			var friction = curve.sample_baked(slip)
			wheel.wheel_friction_slip = friction

		for wheel in rwheels:
			var slip = abs(steering) 
			slip = clamp(slip, 0.0, 2)
			var friction = curve.sample_baked(slip)
			wheel.wheel_friction_slip = friction / 1.05
	for trail in trails:
		if drifting:
			trail.emitting = true
		else:
			trail.emitting = false
			
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


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and not ability_active and not no_recoil:
		Carhp -= 1
	if body.is_in_group("enemies") and no_recoil:
		hit = true
		await get_tree().create_timer(1).timeout
		hit = false
	if body.is_in_group("floor"):
		print(global_position.y)
		if global_position.y <= -5:
			Carhp -= 10
			global_rotation.z = 0
			global_position.y = 0
			print("ow")

func reset():
	global_position = Vector3(0,0,0)
	linear_velocity = Vector3(0,0,0)
	Carhp = 100
	global_rotation = Vector3(0,0,0)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	angular_velocity = Vector3(0,0,0)
	EnemyCount.visible = true
	menu = false
