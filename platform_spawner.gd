extends Node2D

var platform_scene = preload("res://Platform.tscn")
var sliding_platform_scene = preload("res://SlidingPlatform.tscn")
var disappearing_platform_scene = preload("res://DisappearingPlatform.tscn")

var initial_offset = 50
var platform_spacing = 60
var platforms = []

func _ready():
	randomize()
	spawn_initial_platforms()

func _process(_delta):
	var player = get_tree().current_scene.get_node("Player")
	if player: 
		# Spawn new platforms above the screen as needed
		if get_highest_platform_y() > player.position.y - get_viewport_rect().size.y:
			spawn_platform(Vector2(0, player.position.y - get_viewport_rect().size.y - platform_spacing))
		
		# Remove platforms below the player
		cleanup_platforms_below_player(player)

func spawn_initial_platforms():
	var viewport_height = get_viewport_rect().size.y
	var num_platforms = ceil(viewport_height / platform_spacing) + 1

	for i in range(num_platforms):
		spawn_platform(Vector2(0, viewport_height - i * platform_spacing + initial_offset))

func spawn_platform(spawn_position = Vector2()):
	var viewport_width = get_viewport_rect().size.x
	spawn_position.x = randf_range(0, viewport_width)  # Spawns within the entire screen width

	if platforms.size() > 0:
		spawn_position.y = platforms.back().position.y - platform_spacing  # Ensures vertical spacing

	# Randomize platform type
	var platform
	var platform_type = randf()
	if sliding_platform_scene != null and platform_type < 0.15:
		platform = sliding_platform_scene.instantiate()
	elif disappearing_platform_scene != null and platform_type < 0.3:
		platform = disappearing_platform_scene.instantiate()
	elif platform_scene != null:
		platform = platform_scene.instantiate()
	else:
		#print("Error: No platform scene assigned!")
		return

	# Place the platform and add to the scene
	platform.position = spawn_position
	add_child(platform)
	platforms.append(platform)
	#print("Spawned platform at position:", platform.position, "Total platforms:", platforms.size())

func get_highest_platform_y():
	var highest_y = INF  # Start with a very high value
	for i in range(platforms.size() - 1, -1, -1):  # Iterate in reverse to allow safe removal
		var platform = platforms[i]
		
		if !is_instance_valid(platform):  # Skip invalid platforms
			print("Skipping invalid platform reference.")
			platforms.remove_at(i)
			continue

		# Compare valid platform's Y position
		if platform.position.y < highest_y:
			highest_y = platform.position.y

	return highest_y


func cleanup_platforms_below_player(player):
	# Get the player's position and visible viewport height
	var player_y = player.position.y
	var threshold_y = player_y + get_viewport_rect().size.y * 0.5

	for i in range(platforms.size() - 1, -1, -1):  # Iterate in reverse
		var platform = platforms[i]

		if !is_instance_valid(platform):  # Skip invalid platforms
			#print("Skipping invalid platform reference.")
			platforms.remove_at(i)
			continue

		# Remove platform if it's below the player's threshold
		if platform.position.y > threshold_y:
			#print("Removing platform at position:", platform.position)
			platforms.remove_at(i)
			platform.queue_free()
