extends Area2D

@export var speed = 500  # Bullet speed
@export var travel_distance = 1000  # Maximum distance the bullet will travel before disappearing
var start_position = Vector2()  # The position when the bullet is created

@onready var screen_size = get_viewport_rect().size  # Get the screen size

func _ready():
	start_position = position

func _process(delta):
	position.y -= speed * delta

	# distance the bullet has traveled
	var distance_travelled = start_position.y - position.y

	if distance_travelled >= travel_distance:
		queue_free()  

	# Check for collisions with enemies
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):  # If we hit an enemy
			print("Bullet collided with an enemy!")
			ScoreManager.increase_score(10)
			if body.has_method("die"):
				body.die()  # Call the enemy's die function
			queue_free()  # Remove the bullet after it collides
			return  # Exit after the bullet hits the enemy
