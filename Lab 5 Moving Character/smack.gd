extends CharacterBody2D

@onready var collisionShape=$CollisionShape2D
var velocityy = Vector2(0,0)

func _physics_process(delta): 
	var collision_info = move_and_collide(velocityy.normalized())
	if(collision_info):
		handleCollision(collision_info)
		

func handleCollision(collision_info):
	if collision_info.get_collider().is_in_group("enemy"):
		collision_info.get_collider().get_damaged(5)
		self.queue_free()
	#$beaksound.play()
	#await get_tree().create_timer(3).timeout
	#
	
		
