extends CharacterBody2D

@export var verticalVelocity: float
@export var horizontalVelocity: float

func _physics_process(delta):
	#position.x += delta  * horizontalVelocity
	#position.y += delta * verticalVelocity
	var collision = move_and_collide(velocity * delta)
	if (collision):
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		print("player hit")
