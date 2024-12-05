extends Node2D
@export var speed: float = 300
@export var zigzag_amplitude: float = 350
@export var zigzag_frequency: float = 0.01

var direction: int = 1
var initial_y:float
var animated_sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_y = position.y
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("zigzagger")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * speed * delta
	position.y = initial_y + sin(zigzag_frequency * position.x) * zigzag_amplitude
	
	if position.x < 0 or position.x > get_viewport_rect().size.x:
		direction *= -1
