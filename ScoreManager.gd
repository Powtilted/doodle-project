extends Node2D

#@onready var score_label : Label = 

var score: int = 0
var high_score: int = 0
var player: Node = null
var highest_pos: float = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		if current_scene.get_path() == NodePath("/root/main"):
			player = current_scene.get_node("Player")
			if player:
				if player.position.y < highest_pos:
					var distance_moved = abs(highest_pos-  player.position.y)
					increase_score(int(distance_moved / 5))				
					highest_pos = player.position.y

func increase_score(amount: int) -> void:
	score += amount
	if score > high_score:
		high_score = score
	
	
