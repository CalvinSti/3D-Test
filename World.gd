extends Node3D

@onready var enemy_scene: PackedScene = preload("res://Enemy.tscn")
@onready var timer: Timer = $Timer
var random = 0


func _ready() -> void:
	timer.start()
	

func _process(delta: float) -> void:
	random = randf_range(1, 10)

func spawn_idiots(delta: float) -> void:
	if EnemyCount.enemies < 30:
		for i in range(random):
			if EnemyCount.enemies > 25 or EnemyCount.total_enemies > EnemyCount.max_enemies:
				break
			else:
				var enemy_instance = enemy_scene.instantiate()
				add_child(enemy_instance)
				await get_tree().process_frame
	else:
		return

func _on_timer_timeout() -> void:
	spawn_idiots(random)
	timer.start(random * random / random)
