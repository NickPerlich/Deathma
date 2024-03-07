extends CharacterBody2D

var velocityy = Vector2(1,0)
var speed =600

func _physics_process(delta):
	var collision_info = move_and_collide(velocityy.normalized()*delta * speed)


func _on_area_2d_area_entered(area):
	if area.is_in_group("main_character"):
		queue_free()

func changeTexture(texture):
	$Icon.Texture = texture
	return 

func changeCollisionShape(collisionShape):
	$CollisionShape2D.Transform2D.Position
	return 
