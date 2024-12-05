extends CharacterBody2D  

@export var speed: float = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction: int = 1  # 1 = right, -1 = left

# ound or effects when the enemy dies
#@onready var death_sound = $DeathSound

func _ready():
	add_to_group("enemies")
	animated_sprite.play("flapping")

func _process(delta):
	
	position.x += speed * direction * delta

	var space =  get_viewport_rect().size.x
		
	if position.x > space:
		direction = -1
		
	
	elif position.x < 0:
		direction = 1
	
func die():
	queue_free() 
