extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if velocity.y == 0:
		sprite_2d.animation = "default"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		velocity.y += -500.0

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
	
	if Input.is_action_pressed("input_left"):
		sprite_2d.animation = "ma-left"
	elif Input.is_action_pressed("input_right"):
		sprite_2d.animation = "ma-right"
	elif Input.is_action_pressed("input_up"):
		sprite_2d.animation = "ma-up"
	else:
		sprite_2d.animation = "ma-down"
	
	#var flip = velocity.x < 0
	#sprite_2d.flip_h = flip
