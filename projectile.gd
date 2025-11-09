extends RigidBody3D

@export var enemy: PackedScene

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = position.direction_to(enemy.global_position + Vector3(0, 15, 0)).normalized() 
