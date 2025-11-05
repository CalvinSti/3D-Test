extends VehicleBody3D

@export var power := 100
@export var steer := 0.5
@export var sensitivity := 0.0009
@onready var camera = $Twist/Pivot/Camera3D

var twist_pivot := 0.0
var vertical_pivot := 0.0
var ragdoll = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	steering = - move_toward(steering, Input.get_axis("Left", "Right") * steer, delta + 10)
	engine_force = Input.get_axis("Back", "Forward") * power
		
	$Twist.rotate_y(twist_pivot)
	$Twist/Pivot.rotate_z(vertical_pivot)
	
	twist_pivot = 0.0
	vertical_pivot = 0.0
	
	if Input.is_action_just_pressed("R"):
		rotation.z = 0
		global_position = Vector3.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_pivot = -  event.relative.x * sensitivity
			if camera.global_position.y <= 0.099:
				vertical_pivot -= 0.02
			else:
				vertical_pivot = - event.relative.y * sensitivity
				
	print(camera.global_position.y)
