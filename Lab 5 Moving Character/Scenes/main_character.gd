extends CharacterBody2D

const projectilePath = preload("res://projectile.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $Sprite2D
@onready var healthbar = $Healthbar
var bulletCount = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100 : set = _set_health

func _ready():
	healthbar.init_health(health)
	

func _physics_process(delta):
	
	# Add the gravity.
	

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
		


	
	#need to remove health bar from here, for testing
	# movement
	if Input.is_action_pressed("input_left"):
		if health > 0:
			healthbar.decrease_health(1)
		sprite_2d.animation = "ma-left"
	elif Input.is_action_pressed("input_right"):
		if health > 0:
			healthbar.decrease_health(1)
		sprite_2d.animation = "ma-right"
	elif Input.is_action_pressed("input_up"):
		if health > 0:
			healthbar.decrease_health(1)
		sprite_2d.animation = "ma-up"
	elif Input.is_action_pressed("input_down"):
		sprite_2d.animation = "ma-down"
	else:
		sprite_2d.animation = "default"
		
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_global_position()
	$Node2D.look_at(mouse_pos)
	if Input.is_action_just_pressed("shoot"):
		shoot(mouse_pos)
	
func _set_health(value):
	#if health <= 0
		#die
	healthbar.health = health




func _on_tongue_hooked(hooked_position):
	await get_tree().create_timer(0.2).timeout
	var tween = get_tree().create_tween()
	print(self.get_position(), hooked_position)
	
	tween.tween_property(self, "position",Vector2(hooked_position), .5)
	print(self.get_position(), hooked_position)
	velocity = self.get_position() - hooked_position

func shoot(mouse_position):
	var projectile = projectilePath.instantiate()
	get_parent().add_child(projectile)
	
	projectile.position = $Node2D/Marker2D.global_position
	var direction = (mouse_position - projectile.global_position).normalized()
	projectile.velocityy = direction
	
