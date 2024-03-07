extends Sprite2D
@onready var ray_cast=$RayCast2D
var distance:float = 250
# Called when the node enters the scene tree for the first time.

signal hooked(hooked_position)

func interpolate(length, duration = 0.2):
	var tween_offset = get_tree().create_tween()
	var tween_rect_h = get_tree().create_tween()
 
	tween_offset.tween_property(self, "offset",Vector2(0,length/2.0), duration)
	tween_rect_h.tween_property(self, "region_rect", Rect2(16,16,16,length), duration)

func _input(event):
	if event.is_action_pressed("left_click"):
		interpolate(await check_collision(), 0.2)
		await get_tree().create_timer(0.2).timeout
		reverse_interpolate()

func reverse_interpolate():
	interpolate(0,0.55)
	
func check_collision():
	await get_tree().create_timer(0.1).timeout
	var collision_point
	if ray_cast.is_colliding():
		
		var collider = ray_cast.get_collider()
		
		print(collision_point, collider.name)
		#check what it colided with
		if collider.is_in_group("collectible"):
			handle_collision_collectible(collider)
			print(getTexture(collider).name)
		else:
			collision_point = ray_cast.get_collision_point()
			distance = (global_position - collision_point).length()
			hooked.emit(collision_point)
	else:
		distance = 250.0
	return distance
	
func handle_collision_collectible(collider):
	collider.queue_free()

func getTexture(collider):
	for child in collider.get_children():
		if child is Sprite2D:
			return child
