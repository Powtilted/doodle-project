extends Control
@onready var score_label: Label = $Label
@onready var high_label : Label = $Label2

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	score_label.text = str(ScoreManager.score)
	high_label.text = str(ScoreManager.high_score)
	
	
func _on_button_pressed() -> void:
	print("button pressed")
	get_tree().change_scene_to_file("res://start_screen.tscn")
