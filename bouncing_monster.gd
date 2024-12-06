extends CharacterBody2D

@export var speed: float = 100
@export var movement_range = 20



var direction = 1 # 1 for right, -1 for left
var start_x: float
var anim_sprite: AnimatedSprite2D

func _ready():
	add_to_group("enemies")
	start_x = position.x
	anim_sprite = $AnimatedSprite2D
	anim_sprite.play("green_monster")

func _process(delta):
	# Move the enemy left and right
	position.x += speed * direction * delta
	var size = get_viewport_rect().size.x 
	
	if position.x > start_x + movement_range:
		direction = -1 
	elif position.x < start_x - movement_range:
		direction = 1   

func die():
	queue_free()
