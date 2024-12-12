extends Area2D

# Reference to the player
var player = null

#@onready var jetpack_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Assuming the jetpack has an AnimatedSprite2D
#res://jetpack.gd
var jetpack_sprite = preload("res://jetpack.gd")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Check for bodies inside the jetpack's collision shape
	var overlapping_bodies = get_overlapping_bodies()  # Get a list of bodies in the Area2D

	for body in overlapping_bodies:
		if body.is_in_group("player"):  # Check if the body is the player
			player = body
			# Call the boost function in the player's script
			player.boost("jetpack")  # Pass "jetpack" or another type if needed
			
			# Directly access the item_spawner and remove the jetpack
			var item_spawner = get_parent()  # Assuming the item_spawner is the parent of the jetpack
			if item_spawner and item_spawner.has_method("remove_jetpack"):
				item_spawner.remove_jetpack(self)  # Call the method to remove the collected jetpack

			# Queue the jetpack for removal
			queue_free()  # Remove the jetpack item after collision
			break  # No need to check further, remove jetpack after collision
