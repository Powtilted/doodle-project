extends Node2D

@export var platform_scene: PackedScene
var initial_offset = 100 
var platform_spacing = 100
var platforms = []

func _ready():
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
	
	var platform = platform_scene.instantiate()
	platform.position = spawn_position
	add_child(platform)
	platforms.append(platform)
	print("Spawned platform at position:", platform.position, "Total platforms:", platforms.size())

func get_highest_platform_y():
	if platforms.is_empty():
		return INF
	return platforms[0].position.y

func cleanup_platforms_below_player(player):
	# Get the player's position and visible viewport height
	var player_y = player.position.y
	var threshold_y = player_y + get_viewport_rect().size.y * 0.2  

	# Iterate through the platforms array
	for i in range(platforms.size() - 1, -1, -1):
		var platform = platforms[i]

		# Remove platform if it's just below the player's threshold
		if platform.position.y > threshold_y:
			platforms.remove_at(i)  # Remove from the array
			platform.queue_free()  # Free the platform node
			print("Removed platform at position:", platform.position)
 
