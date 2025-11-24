extends Node

var selected_vehicle : PackedScene = null
var vehicle_instance : Node = null
@onready var player_car = VehicleManager.vehicle_instance

var vehicles := {
	"Car": preload("res://Car.tscn"),
	"Test": preload("res://test-car.tscn")
}

func _ready() -> void:
	VehicleManager.visible = false

func set_vehicle(name: String) -> void:
	if vehicles.has(name):
		selected_vehicle = vehicles[name]

func spawn_vehicle(parent: Node) -> Node:
	if vehicle_instance:
		vehicle_instance.queue_free()
	
	vehicle_instance = selected_vehicle.instantiate()
	parent.add_child(vehicle_instance)
	return vehicle_instance
	Global.Car = vehicle_instance

func _on_car_1_pressed() -> void:
	VehicleManager.set_vehicle("Car")
	var car = VehicleManager.spawn_vehicle(self)
	Global.Car = vehicle_instance
	Global.Car.menu = true
	
func _on_car_2_pressed() -> void:
	VehicleManager.set_vehicle("Test")
	var car = VehicleManager.spawn_vehicle(self)
	Global.Car = vehicle_instance 
	Global.Car.menu = true

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("node_3d.tscn")
	Global.Car.menu = false
	Global.Car.call_deferred("reset")
	VehicleManager.visible = false
	EnemyCount.visibl()


func _on_back_pressed() -> void:
	VehicleManager.visible = false
	startmenu.visible = true
