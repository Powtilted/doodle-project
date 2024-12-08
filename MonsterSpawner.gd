extends Node2D

@export var platform_scene: PackedScene
@export var sliding_platform_scene: PackedScene
@export var disappearing_platform_scene: PackedScene

var initial_offset = 50
var platform_spacing = 120  # Maximum vertical distance between platforms
var min_horizontal_spacing = 100  # Minimum horizontal spacing between platforms
var platforms = []
var spawn_buffer = 100  # Minimum distance above player to spawn platforms

func _ready():
	randomize()
	spawn_initial_platforms()

func _process(_delta):
	var player = get_tree().current_scene.get_node("Player")
	if player:
		# Spawn new platforms as needed
		if get_highest_platform_y() > player.position.y - get_viewport_rect().size.y:
			spawn_platform(Vector2(0, player.position.y - get_viewport_rect().size.y - platform_spacing))

func spawn_initial_platforms():
	var viewport_height = get_viewport_rect().size.y
	var num_platforms = ceil(viewport_height / platform_spacing) + 1

	var player = get_tree().current_scene.get_node("Player")
	var player_y = player.position.y if player else 0

	for i in range(num_platforms):
		var spawn_y = viewport_height - i * platform_spacing + initial_offset
		if spawn_y < player_y + spawn_buffer:
			spawn_y = player_y + spawn_buffer

		spawn_platform(Vector2(randf() * get_viewport_rect().size.x, spawn_y))

func spawn_platform(spawn_position = Vector2()):
	var viewport_width = get_viewport_rect().size.x
	var platform
	var safe_margin = 50

	# Randomize the X position
	spawn_position.x = safe_margin + randf() * (viewport_width - 2 * safe_margin)

	# Adjust vertical position to respect maximum spacing
	if platforms.size() > 0:
		var last_platform_y = platforms.back().position.y
		# Ensure the new platform is no farther than platform_spacing
		spawn_position.y = max(last_platform_y - platform_spacing, spawn_position.y)

	# Enforce minimum spacing between new platform and all existing platforms
	for existing_platform in platforms:
		var distance = existing_platform.position.distance_to(spawn_position)
		if distance < min_horizontal_spacing:
			# Reposition to avoid overlap
			spawn_position.x = randf() * (viewport_width - 2 * safe_margin) + safe_margin
			spawn_position.y = existing_platform.position.y - platform_spacing

	# Randomize platform type
	var platform_type = randf()
	if sliding_platform_scene != null and platform_type < 0.15:
		platform = sliding_platform_scene.instantiate()
	elif disappearing_platform_scene != null and platform_type < 0.3:
		platform = disappearing_platform_scene.instantiate()
	elif platform_scene != null:
		platform = platform_scene.instantiate()
	else:
		print("Error: No platform scene assigned!")
		return

	# Place the platform and add to the scene
	platform.position = spawn_position
	add_child(platform)
	platforms.append(platform)

func get_highest_platform_y():
	if platforms.is_empty():
		return INF
	return platforms[0].position.y

func cleanup_platforms_below_player(player):
	var player_y = player.position.y
	var threshold_y = player_y + get_viewport_rect().size.y * 0.5  # Keep platforms longer on-screen

	for i in range(platforms.size() - 1, -1, -1):
		var platform = platforms[i]
		if platform.position.y > threshold_y:
			platforms.remove_at(i)  # Remove from the array
			platform.queue_free()  # Free the platform node
