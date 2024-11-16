extends Area2D

@export var speed = 500  
@onready var screen_size = get_viewport_rect().size

func _process(delta):
	# Move the bullet upwards
	position.y -= speed * delta 
	if position.y > screen_size.y or position.y < 0:
		queue_free()  # Remove bullet if it goes offscreen
		
	# Check for overlapping bodies (collision detection)
	var bodies = get_overlapping_bodies() 
	for body in bodies:
		if body.is_in_group("enemies"):
			print("Bullet collided with an enemy!")  # Debugging print
			if body.has_method("die"):
				print("Calling enemy die method")  # Debugging print
				body.die()  # Call the enemy's die function if it exists
			else:
				print("Enemy does not have a die method!")  # Debugging print
			queue_free()  # Remove the bullet after it collides
			return
