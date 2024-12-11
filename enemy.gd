extends CharacterBody2D

var speed = 100   # Speed of the enemy
var direction = 1 # 1 for right, -1 for left
@onready var death_sound = $DeathSound  # Reference the DeathSound node

func _ready():
	add_to_group("enemies")

func _process(delta):
	# Move the enemy left and right
	position.x += speed * direction * delta
	
	# Change direction when reaching a certain distance
	if position.x > 200:
		direction = -1  # Move left
	elif position.x < 20:
		direction = 1   # Move right

func die():
	if death_sound:
		death_sound.play()
		await get_tree().create_timer(0.05).timeout  # Small delay to allow sound to play
	queue_free()
