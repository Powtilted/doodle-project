extends Control
@onready var high_label : Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	high_label.text = str(ScoreManager.high_score)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_button_pressed() -> void:
	#var main_game_scene = preload("res://node_2d.tscn")
	await get_tree().create_timer(0).timeout
	get_tree().change_scene_to_file("res://node_2d.tscn")
