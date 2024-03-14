extends CharacterBody2D

@export var verticalVelocity: float
@export var horizontalVelocity: float

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if (collision):
		queue_free()

