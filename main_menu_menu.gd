extends Node2D

func _ready() -> void:
	Car.menu = true

func _process(delta: float) -> void:
	if get_tree().current_scene.scene_file_path.ends_with("Main-Menu.tscn"):
		visible = true
	else:
		visible = false

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("node_3d.tscn")
	Car.call_deferred("reset")
	EnemyCount.call_deferred("visibl")
	
