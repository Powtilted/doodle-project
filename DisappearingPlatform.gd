extends StaticBody2D

@export var break_delay: float = 0.5  # Time before breaking
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

# Triggered when a body enters the Area2D
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):  # Ensure it's the player
		print("Player landed on the platform!")
		start_breaking()

# Break the platform after a delay
func start_breaking():
	sprite.modulate = Color(1, 0.5, 0.5)  # Visual feedback
	await get_tree().create_timer(break_delay).timeout
	print("Breaking platform!")
	collision_shape.disabled = true  # Disable collision
	queue_free()
