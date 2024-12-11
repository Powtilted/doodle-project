extends StaticBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

# Trigger when collided with
func delete_platform():
	print("Platform collided and is being deleted!")
	collision_shape.disabled = true  # Disable collision immediately
	await get_tree().create_timer(0.1).timeout
	queue_free()  # Remove the platform immediately
