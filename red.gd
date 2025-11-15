extends Node3D

# Pulse speed and strength
@export var pulse_speed: float = 4.0
@export var pulse_strength: float = 2.0

@onready var mat = $MeshInstance3D

func _ready() -> void:
	mat.material_override = mat.get_active_material(0)

func _process(delta: float) -> void:
	var t = sin(Time.get_ticks_msec() / 1000.0 * pulse_speed)
	var intensity = 1.0 + t * pulse_strength  # Pulsing energy
	
	mat.emission_energy = max(intensity, 0.0)
