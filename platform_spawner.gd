extends Node2D

@export var platform_scene: PackedScene
var initial_offset = 100  # Adjust this value as needed
var platform_spacing = 100
var platforms = []

func _ready():
	spawn_initial_platforms()

func _process(_delta):
	var player = get_tree().current_scene.get_node("Player")
	if player:
		print("Player Y:", player.position.y, "Lowest Platform Y:", get_lowest_platform_y())
		# Continuously spawn platforms as the player moves up
		if player.position.y < get_lowest_platform_y() + platform_spacing:  # Changed condition
			spawn_platform()

func spawn_initial_platforms():
	for i in range(5):
		spawn_platform(Vector2(0, -i * platform_spacing + initial_offset))

func spawn_platform(spawn_position = Vector2()):
	var viewport_width = get_viewport_rect().size.x
	spawn_position.x = randf_range(0, viewport_width)  # Spawns within the entire screen width
	
	# Adjust the y-position for newly spawned platforms
	if platforms.size() > 0:
		spawn_position.y = platforms.back().position.y - platform_spacing  # Ensures vertical spacing
	
	var platform = platform_scene.instantiate()
	platform.position = spawn_position
	add_child(platform)
	platforms.append(platform)
	print("Spawned platform at position:", platform.position, "Total platforms:", platforms.size())



func get_lowest_platform_y():
	if platforms.size() == 0:
		return 0
	return platforms.back().position.y
