extends CharacterBody2D

const projectilePath = preload("res://projectile.tscn")
const smackPath = preload("res://smack.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const RAGE_METER_SCALE_FACTOR = 10
@onready var sprite_2d = $Sprite2D
@onready var healthbar = $Healthbar
@onready var inventory = $Inventory
@onready var rage_anim = $AnimationPlayer
var bulletCount = 0
var curTexture = 0
var curCollisionShape = 0
var curRect_region = 0
var bulletList = []
var level2 = false
var rageMode = false
var rageScore = 20;
var rageMaxTime = 10
var smackbool = false
var kickMode = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100 : set = _set_health

func _ready():
	healthbar.init_health(health)
	add_to_group("Player")
	
func _physics_process(delta):
	
	# Add the gravity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdirection = Input.get_axis("input_left", "input_right")
	var ydirection = Input.get_axis("input_up", "input_down")
	if xdirection:
		velocity.x = xdirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if ydirection:
		velocity.y = ydirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	#collision logic
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		handle_char_collision(collision)
	
	# movement
	if Input.is_action_pressed("input_left"):
		sprite_2d.animation = "ma-left"
	elif Input.is_action_pressed("input_right"):
		sprite_2d.animation = "ma-right"
	elif Input.is_action_pressed("input_up"):
		sprite_2d.animation = "ma-up"
	elif Input.is_action_pressed("input_down"):
		sprite_2d.animation = "ma-down"
	else:
		sprite_2d.animation = "default"
		
	#Rage control
	if Input.is_action_just_pressed("enterRage"):
		if rageScore < 10:
			print("not enough rage")
		else: 
			#enter Rage
			enterRageMode()
		
func handle_char_collision(col):
	var collider = col.get_collider()
	if collider.is_in_group("enemy") and kickMode:
		collider.get_damaged(2)
		
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_global_position()
	$Node2D.look_at(mouse_pos)
	if Input.is_action_just_pressed("shoot") :
		if !rageMode:
			if bulletList.size():
				shoot(mouse_pos)
				inventory.use_first_available_item()
				bulletCount -=1
			 
		elif !smackbool:
			#rage swipe
			$slap.play()
			rageSmack(mouse_pos)
			
	if healthbar.health <= 0:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	if level2 == true:
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
		

	#await get_tree().create_timer(1.0).timeout
		#get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
		#
func enterRageMode():
	rageMode = true
	print("in raged")
	rage_anim.play("Rage Overlay")
	await get_tree().create_timer(10).timeout
	deactivateRageMode()
	
func deactivateRageMode():
	rageMode = false
	rageScore = 0
	
func addRage(amount):
	var rage_meter = $RageMeter
	rageScore += amount
	rage_meter.value = rageScore * RAGE_METER_SCALE_FACTOR
	
func _set_health(value):
	#if health <= 0
		#die
	healthbar.health = health

func _on_tongue_hooked(hooked_position):
	await get_tree().create_timer(0.2).timeout
	var tween = get_tree().create_tween()

	
	tween.tween_property(self, "position",Vector2(hooked_position)-$pivot.position, .5)

	velocity = self.get_position() - hooked_position

func shoot(mouse_position):
		addRage(2)
		$shootSound.play()
		var bullet = bulletList.pop_back()
		var projectile = projectilePath.instantiate()
		projectile.changeCollisionShape(bullet.collisionShape)
		projectile.changeTexture(bullet.texture,bullet.rect_region)
		get_parent().add_child(projectile)
		
		projectile.position = $Node2D/Marker2D.global_position
		var direction = (mouse_position - projectile.global_position).normalized()
		projectile.velocityy = direction

func rageSmack(mouse_position):
	print("rage smack")
	
	smackbool = true
	var smack = smackPath.instantiate()
	get_parent().add_child(smack)
	smack.position = $Node2D/Marker2D.global_position
	
	
	if is_instance_valid(smack):
		await get_tree().create_timer(.2).timeout
		if is_instance_valid(smack):
			smack.queue_free() 
		smackbool = false
	
func handle_rage_jump(pos):
	await get_tree().create_timer(0.2).timeout
	var tween = get_tree().create_tween()
	kickMode = true
	tween.tween_property(self, "position",Vector2(pos)-$pivot.position, .3)
	await tween.finished
	kickMode = false

func _on_tongue_collected(texture, collisionShape, rect_region):
	bulletCount += 1
	var bullet = {
		"collisionShape": collisionShape,
		"texture": texture,
		"rect_region": rect_region
	}
	bulletList.append(bullet)

	

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy_projectile"):
		if health > 0 and !rageMode:
			addRage(3)
			healthbar.decrease_health(20)
			$hurtSound.play()
			print("player damaged")
		else:
			print("cant damage rageMa")

	if area.is_in_group("portal"):
		level2 = true
