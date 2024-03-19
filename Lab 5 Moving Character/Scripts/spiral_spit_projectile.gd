class_name SpiralSpitProjectile
extends CharacterBody2D

@export var init_radius = 1  
@export var growth_rate = 0.1  
@export var speed = 100

var theta = 0  

func _physics_process(delta):
	var delta_theta = speed / (init_radius * exp(growth_rate * theta))
	theta += delta_theta * delta
	
	# Calculate the new position based on the logarithmic spiral equation
	var r = init_radius * exp(growth_rate * theta)
	var x = r * cos(theta)
	var y = r * sin(theta)
	
	# Update the object's position
	position = Vector2(x, y)
	var collision = move_and_collide(velocity * delta)
	if (collision):
		queue_free()
