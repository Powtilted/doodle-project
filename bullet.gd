extends Area2D

@export var speed = 500  
@onready var screen_size = get_viewport_rect().size

func _process(delta):
	position.y -= speed * delta 
	if position.y > screen_size.y or position.y < 0:
		queue_free()  
		
	var bodies = get_overlapping_bodies() 
	for body in bodies:
		if body.is_in_group("enemies"):
			body.queue_free() 
			queue_free()
			return 
