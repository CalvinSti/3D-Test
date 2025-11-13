extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_range: float = 300
@onready var timer: Timer = $Timer
var random = 0


func _ready() -> void:
	timer.start()

func _process(delta: float) -> void:
	random = randf_range(1, 5)

func spawn_idiots(delta: float) -> void:
	if EnemyCount.enemies < 30:
		for i in range(random):
			if EnemyCount.enemies > 30:
				break
			else:
				var enemy_instance = enemy_scene.instantiate()
				add_child(enemy_instance)
				EnemyCount.enemies = EnemyCount.enemies + 1
	else:
		return
	timer.start(random * random - random)


func _on_timer_timeout() -> void:
	spawn_idiots(random)
