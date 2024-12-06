extends Node2D

@export var monster_scene: PackedScene
@export var zigzag_monster_scene: PackedScene
@export var bouncing_monster_scene: PackedScene

var initial_offset = 50
var monster_spacing = 1000
var monsters = []
var spawn_buffer = 500  

func _ready():
	randomize()
	spawn_initial_monsters()

func _process(_delta):
	var player = get_tree().current_scene.get_node("Player")
	if player:
	
		if get_highest_monster_y() > player.position.y - get_viewport_rect().size.y:
			spawn_monster(Vector2(0, player.position.y - get_viewport_rect().size.y - monster_spacing))

func spawn_initial_monsters():
	var viewport_height = get_viewport_rect().size.y
	var num_monsters = ceil(viewport_height / monster_spacing) + 1

	
	var player = get_tree().current_scene.get_node("Player")
	var player_y = player.position.y if player else 0  

	for i in range(num_monsters):
		
		var spawn_y = viewport_height - i * monster_spacing + initial_offset

		if spawn_y < player_y + spawn_buffer:  
			spawn_y = player_y + spawn_buffer  
		

		#spawn_monster(Vector2(0, spawn_y))
		spawn_monster(Vector2(randf() * get_viewport_rect().size.x, spawn_y))

func spawn_monster(spawn_position = Vector2()):
	var viewport_width = get_viewport_rect().size.x
	var monster
	var safe_margin = 50

	#spawn_position.x = randf() * viewport_width 	
	spawn_position.x = safe_margin + randf() * (viewport_width - 2 * safe_margin)
	if monsters.size() > 0:
		spawn_position.y = monsters.back().position.y - monster_spacing
	
	if randf() < 0.1:
		monster = zigzag_monster_scene.instantiate()
		#
	elif randf() < 0.4:
		monster = bouncing_monster_scene.instantiate()
	else:
		monster = monster_scene.instantiate()
	#var monster = monster_scene.instantiate()
	

	
	monster.position = spawn_position
	add_child(monster)
	monsters.append(monster)
	

func get_highest_monster_y():
	if monsters.is_empty():
		return INF
	return monsters[0].position.y

func cleanup_monsters_below_player(player):
	var player_y = player.position.y
	var threshold_y = player_y + get_viewport_rect().size.y * 0.1  

	for i in range(monsters.size() - 1, -1, -1):
		var monster = monsters[i]

		
		if monster.position.y > threshold_y:
			monsters.remove_at(i)  # Remove from the array
			monster.queue_free()  # Free the monster node
