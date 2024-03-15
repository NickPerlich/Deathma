extends CharacterBody2D

@onready var collisionShape=$CollisionShape2D
@onready var areaCollisionShape=$Area2D/CollisionShape2D
var velocityy = Vector2(1,0)
var speed =600

func _physics_process(delta):
	var collision_info = move_and_collide(velocityy.normalized()*delta * speed)
	if(collision_info):
		handleCollision(collision_info)

func _process(delta):
	rotate(5*delta)

func changeTexture(texture, region_rect):
	$Icon.set_texture(texture)
	$Icon.region_enabled = true
	$Icon.region_rect = region_rect
	return 


func changeCollisionShape(collisionShape):
	$CollisionShape2D.position = collisionShape
	return 

func handleCollision(collision_info):
	if collision_info.get_collider().is_in_group("enemy"):
		collision_info.get_collider().get_damaged()
	$breakSound.play()
	self.queue_free()
