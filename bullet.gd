extends Area2D

@export var speed = 500  # Bullet speed
@onready var screen_size = get_viewport_rect().size  # Get screen size
@onready var camera = get_parent().get_node("Camera2D")  # Get the Camera2D node

func _process(delta):
	# Move the bullet upwards
	position.y -= speed * delta  # Move upwards

	# If the bullet moves above the camera's view, queue it for removal
	if camera:
		var camera_pos = camera.position
		if position.y < camera_pos.y - screen_size.y / 2:  # Bullet is off the top of the screen
			queue_free()  # Remove the bullet if it's off the top of the screen
			return

	# Check for collisions with enemies
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):  # If we hit an enemy
			print("Bullet collided with an enemy!")
			if body.has_method("die"):
				body.die()  # Call the enemy's die function
			queue_free()  # Remove the bullet after it collides
			return  # Exit after the bullet hits the enemy
