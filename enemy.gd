extends CharacterBody2D

var speed = 100   # Speed of the enemy
var direction = 1 # 1 for right, -1 for left

func _ready():
	add_to_group("enemies")
	
	
func _process(delta):
	# Move the enemy left and right
	position.x += speed * direction * delta
	
	# Change direction when reaching a certain distance
	if position.x > 200:
		direction = -1  # Move left
	elif position.x < 20:
		direction = 1   # Move right
