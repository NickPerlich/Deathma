extends Sprite2D
@onready var ray_cast=$RayCast2D
@onready var ray_cast2=$RayCast2D2
@onready var player = $"../.."
var distance:float = 450

# Called when the node enters the scene tree for the first time.

signal hooked(hooked_position)
signal collected(texture, collision)
signal jumped(jump_position)


func interpolate(length, duration = 0.2):
	var tween_offset = get_tree().create_tween()
	var tween_rect_h = get_tree().create_tween()
 
	tween_offset.tween_property(self, "offset",Vector2(0,length/2.0), duration)
	tween_rect_h.tween_property(self, "region_rect", Rect2(16,16,16,length), duration)

func _input(event):
	
	if event.is_action_pressed("left_click"):
		if player.rageMode:
			rageJump()
			
		else:
			$slurpSound.play()
			interpolate(await check_collision(), 0.2)
			await get_tree().create_timer(0.2).timeout
			reverse_interpolate()

func rageJump():
	await get_tree().create_timer(0.2).timeout
	var target_position
	if ray_cast2.is_colliding():
		target_position = ray_cast.get_collision_point()
		
		
	else:
		var dir = get_global_mouse_position()-player.global_position
		dir = dir.normalized() * 600
		target_position = player.global_position + dir
	
	player.handle_rage_jump(target_position)
	
func reverse_interpolate():
	interpolate(0,0.55)
	
func check_collision():
	await get_tree().create_timer(0.1).timeout
	var collision_point
	if ray_cast.is_colliding():
		
		var collider = ray_cast.get_collider()
		

		#check what it colided with
		if collider.is_in_group("collectible"):
			handle_collision_collectible(collider)
			collected.emit(getSprite(collider).texture, getCollisionShape(collider).position, getSprite(collider).region_rect)
		elif collider.is_in_group("enemyProjectile"):
			collider.queue_free()
			print("hit")
		else:
			collision_point = ray_cast.get_collision_point()
			distance = (global_position - collision_point).length()
			hooked.emit(collision_point)
	else:
		distance = 450.0
	return distance
	
func handle_collision_collectible(collider):
	var cloned_item = getSprite(collider).duplicate()  # Clone the current item
	cloned_item.texture = getSprite(collider).texture
	cloned_item.region_rect = getSprite(collider).region_rect
	cloned_item.region_enabled = true
	Global.add_item_to_inventory(cloned_item)  # Add the cloned item to the global inventory
	var inventory_node = $"../../Inventory"
	if inventory_node:
		inventory_node.update_inventory_UI()
	else:
		print("Failed to find inventory node")
	#queue_free()  # Remove the original item from the game world
	collider.queue_free()

func getSprite(collider):
	for child in collider.get_children():
		if child is Sprite2D:
			return child

func getCollisionShape(collider):
	for child in collider.get_children():
		if child is CollisionShape2D:
			return child
