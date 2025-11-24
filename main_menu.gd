extends  Node3D

var selected_vehicle : PackedScene = null
var player_vehicle_instance : Node = null

var vehicles := {
	"Car" : preload("res://Car.tscn"),
	"Test" : preload("res://test-car.tscn")
}

func set_vehicle(name: String):
	selected_vehicle = vehicles[name]

func spawn_player_vehicle(parent: Node) -> Node:
	if selected_vehicle == null:
		push_error("No vehicle selected!")
		return null

	player_vehicle_instance = selected_vehicle.instantiate()
	parent.add_child(player_vehicle_instance)
	return player_vehicle_instance


@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var start_menu: Node2D = $CanvasGroup/StartMenu
@onready var vehicle_selector: Node2D = $CanvasGroup/VehicleSelector

func _ready() -> void:
	var car = VehicleManager.spawn_player_vehicle(self)
	Car.current.menu = true
	start_menu.visible = true
	VehicleManager.visible = false
	Car.current = car  # store reference globally if needed


func _physics_process(delta: float) -> void:
	rigid_body_3d.apply_torque(Vector3.UP * Input.get_axis("Left", "Right") * 2.5)

	Car.rotation.y = lerp_angle(Car.rotation.y, rigid_body_3d.rotation.y, 2.5 * delta)

func _on_start_pressed() -> void:
	vehicle_selector.visible = true
	start_menu.visible = false


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("node_3d.tscn")
	Car.menu = false
	Car.call_deferred("reset")
	EnemyCount.visibl()


func _on_back_pressed() -> void:
	vehicle_selector.visible = false
	start_menu.visible = true


func _on_car_1_pressed() -> void:
	var car = VehicleManager.spawn_player_vehicle(self)
	Car.current = car  # store reference globally if needed
	VehicleManager.set_vehicle("Car")
	
func _on_car_2_pressed() -> void:
	selected_vehicle.set_vehicle("Test")
