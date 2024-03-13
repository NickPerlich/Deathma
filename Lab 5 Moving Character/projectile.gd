extends CharacterBody2D

@onready var collisionShape=$CollisionShape2D
var velocityy = Vector2(1,0)
var speed =600

func _physics_process(delta):
	var collision_info = move_and_collide(velocityy.normalized()*delta * speed)
	if(collision_info):
		handleCollision(collision_info)

func _process(delta):
	rotate(5*delta)
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("main_character"):
		queue_free()

func changeTexture(texture, region_rect):
	$Icon.set_texture(texture)
	$Icon.region_enabled = true
	$Icon.region_rect = region_rect
	return 


func changeCollisionShape(collisionShape):
	$CollisionShape2D.position = collisionShape
	
	print("shape changed to", $CollisionShape2D.position)
	return 

func handleCollision(collision_info):
	#break obj
	$breakSound.play()
	self.queue_free()
