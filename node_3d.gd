extends RigidBody3D

var player = Car
var speed := 50
var collided = false
@onready var timer = $Timer

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10

func _process(delta: float) -> void:
	var direciton = position.direction_to(Car.global_position).normalized()
	
	if collided:
		if linear_velocity.length() < 0.01 and timer.is_stopped() and angular_velocity.length() < 0.01:
			timer.start(3.0)
	else:
		timer.stop()
		linear_velocity = (direciton * speed)
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	set_axis_velocity(linear_velocity)
	
	#print(collided,"  ", angular_velocity.length(), "  ", linear_velocity.length())
	#print(timer.time_left)
	
func _on_body_entered(_body: Node) -> void:
	if _body == player and not collided:
		collided = true
		timer.stop()
		var knockback_dir = - position.direction_to(Car.global_position).normalized()
		var impulse = (knockback_dir + Vector3.UP * 0.5).normalized() * 15.0
		apply_central_impulse(impulse * mass)
		apply_torque_impulse(Vector3(randf(), randf(), randf()) * 10.0)
	if _body == player and collided:
		timer.stop()

func _on_timer_timeout() -> void:
	collided = false
