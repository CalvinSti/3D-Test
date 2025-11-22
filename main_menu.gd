extends  Node3D

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	rigid_body_3d.apply_torque(Vector3.UP * Input.get_axis("Left", "Right") * 2.5)

	Car.rotation.y = lerp_angle(Car.rotation.y, rigid_body_3d.rotation.y, 2.5 * delta)
