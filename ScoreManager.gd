extends Node2D

#@onready var score_label : Label = 

var score: int = 0
var score_timer: float = 0
var score_interval: float = 2
var high_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	print("Scoremanager instance create: ", get_path())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	score_timer += delta
	if score_timer >= score_interval:
		score_timer -= score_interval
		increase_score(1)



func increase_score(amount: int) -> void:
	score += amount
	if score > high_score:
		high_score = score
	print("Score: ", score )
	
	
