extends Node2D
var enemies = 0
var total_enemies = 0
var kills = 0
var max_enemies = 50

@onready var text_edit: TextEdit = $TextEdit
@onready var label: Label = $Label

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	text_edit.text = str(EnemyCount.kills) 
	if EnemyCount.kills == EnemyCount.max_enemies:
		label.visible = true
