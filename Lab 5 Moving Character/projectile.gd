extends CharacterBody2D

var velocityy = Vector2(1,0)
var speed =600

func _physics_process(delta):
	var collision_info = move_and_collide(velocityy.normalized()*delta * speed)
