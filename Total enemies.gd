extends Node2D
var enemies = 0
var total_enemies = 0
var kills = 0
var max_enemies = 50
@onready var text_edit_2: TextEdit = $TextEdit2

@onready var text_edit: TextEdit = $TextEdit
@onready var label: Label = $Label
@onready var text_edit_3: TextEdit = $TextEdit3
@onready var text_edit_4: TextEdit = $TextEdit4
@export var texts: Array[TextEdit]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	text_edit.text = "Player kills: %s" % str(EnemyCount.kills)
	text_edit_2.text = "Hp: %s" % str(Car.Carhp)
	text_edit_3.text = "Drifting %s" % str(Car.drifting)
	text_edit_4.text = "No recoil %s" % str(Car.no_recoil)
	if EnemyCount.kills == EnemyCount.max_enemies:
		label.visible = true

func visibl():
	for text in texts:
		text.visible = true
