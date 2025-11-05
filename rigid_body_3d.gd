extends RigidBody3D

var sensitivity := 0.0007
var twist := 0.0
var pivot := 0.0

@onready var pitch := $twist/pivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	var input = Vector3.ZERO
	input.z = Input.get_axis("Forward", "Back")
	input.x = Input.get_axis("Left", "Right")
	
	apply_central_force($twist.basis * input * 1200.0 * delta)
	
	if Input.is_action_just_pressed("Jump"):
		linear_velocity.y += 10
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("Forward"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$twist.rotate_y(twist)
	pitch.rotate_x(pivot)
	pitch.rotation.x = clamp(
		pitch.rotation.x,
		-0.5,
		0.5
	)
	pivot = 0.0
	twist = 0.0
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist = - event.relative.x * sensitivity
			pivot = - event.relative.y * sensitivity
