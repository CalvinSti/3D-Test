extends Node2D

func _ready() -> void:
	startmenu.visible = true

func _on_start_pressed() -> void:
	VehicleManager.visible = true
	startmenu.visible = false
	visible = false
