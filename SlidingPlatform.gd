extends Node2D

@export var speed: float = 100  # Speed of the platform
@export var movement_range: float = 300  # Horizontal range of movement

var direction = 1  # 1 for right, -1 for left
var start_x: float  # Starting X position for movement

func _ready():
	# Record the starting X position
	start_x = position.x

func _process(delta):
	# Move the platform left and right
	position.x += speed * direction * delta

	# Get the viewport width
	var viewport_width = get_viewport_rect().size.x

	# Reverse direction if it hits the movement range
	if position.x > start_x + movement_range or position.x > viewport_width:
		direction = -1
		position.x = min(position.x, viewport_width)  # Clamp to viewport edge
	elif position.x < start_x - movement_range or position.x < 0:
		direction = 1
		position.x = max(position.x, 0)  # Clamp to viewport edge
