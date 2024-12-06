extends Area2D

signal player_collided

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("player_collided")
		body.shrink_and_disappear()
