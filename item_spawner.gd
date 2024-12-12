extends Node2D

# Preload jetpack scene
var jetpack_scene = preload("res://jetpack.tscn")

# Variables for item management
var items = []
var item_spacing = 1000  # Vertical space between items
var safe_margin = 500  # Horizontal margin for spawning
var item_spawn_chance = 0.01  # The chance to spawn an item (1 means always spawn)
var max_items = 1  # Maximum number of items allowed in the scene
var min_item_spacing = 5000  # Minimum distance between spawned items vertically
var cleanup_interval = 1.0  # Time in seconds between cleanup checks
var last_cleanup_time = 0.0  # Time since last cleanup check

func _ready() -> void:
	randomize()  # Ensure random item placement each time

func _process(delta: float) -> void:
	var player = get_tree().current_scene.get_node("Player")
	
	if player:
		# Reduce the frequency of cleanup checks
		last_cleanup_time += delta
		if last_cleanup_time >= cleanup_interval:
			cleanup_items_below_player(player)
			last_cleanup_time = 0.0  # Reset cleanup timer
		
		# Spawn items above the player if the number of items is less than max_items
		if len(items) < max_items:
			# Ensure spawn only if the highest item is sufficiently above the player
			if items.is_empty() or get_highest_item_y() < player.position.y - get_viewport_rect().size.y:
				#print("Spawning new item above player.")
				spawn_item(Vector2(
					safe_margin + randf() * (get_viewport_rect().size.x - 2 * safe_margin),
					get_valid_spawn_y(player)  # Pass the player object here to the function
				))
func spawn_item(spawn_position: Vector2) -> void:
	# Randomize the x-coordinate across the entire screen width, within the safe margin
	spawn_position.x = randf() * get_viewport_rect().size.x
	
	# Check if the random chance for spawning is met
	if randf() < item_spawn_chance:
		var item = jetpack_scene.instantiate()  # Instantiate a new jetpack item
		if item:
			item.position = spawn_position  # Set the randomized position
			add_child(item)  # Add the item to the scene
			items.append(item)  # Add the item to the list of items
			
func get_highest_item_y() -> float:
	# Returns the Y position of the highest item in the scene or -INF if no items exist
	if items.is_empty():
		print("No items in the scene yet.")
		return -INF  # Return a value that indicates no valid items exist
	
	# Check the items array to ensure all items are valid
	var highest_y = -INF
	for item in items:
		if item != null and item.is_inside_tree():  # Ensure the item is not null and still inside the tree
			highest_y = max(highest_y, item.position.y)  # Get the highest Y position
	return highest_y

func get_valid_spawn_y(player) -> float:
	# Calculate a valid spawn Y position for items ensuring proper spacing
	var spawn_y = player.position.y - get_viewport_rect().size.y - item_spacing
	spawn_y = clamp(spawn_y, player.position.y - get_viewport_rect().size.y * 2, player.position.y - get_viewport_rect().size.y)
	
	# Add randomness to spawn Y position while respecting minimum spacing between items
	var offset = randf_range(-min_item_spacing, min_item_spacing)  # Random offset within the minimum spacing
	spawn_y += offset

	# Ensure no overlap with other items by checking their positions (now limited to only relevant items)
	for item in items:
		if item != null and item.is_inside_tree():
			var distance = abs(spawn_y - item.position.y)
			if distance < min_item_spacing:
				spawn_y = item.position.y - min_item_spacing + randf_range(-min_item_spacing, min_item_spacing)  # Re-adjust if too close

	return spawn_y

func cleanup_items_below_player(player):
	var player_y = player.position.y
	var threshold_y = player_y + get_viewport_rect().size.y * 0.5  # Adjust the margin for cleanup

	# Iterate through the items in reverse order to safely remove them
	for i in range(items.size() - 1, -1, -1):
		var item = items[i]
		# Check if the item is not null and still inside the tree
		if item != null and item.is_inside_tree() and item.position.y > threshold_y:
			var item_position = item.position  # Store position before removal
			items.remove_at(i)  # Safely remove from the array by index
			#print("Removed item below player at: ", item_position)
			item.queue_free()  # Free the item node

# Method to remove a jetpack from the item list when it is collected
func remove_jetpack(jetpack) -> void:
	# Ensure the jetpack is removed from the items array
	if jetpack in items:
		items.erase(jetpack)
		#print("Removed jetpack from items list.")
	#else:
		#print("Jetpack not found in items list.")
