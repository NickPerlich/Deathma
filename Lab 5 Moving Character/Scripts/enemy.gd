extends CharacterBody2D

@export var moveSpeed: int = 80
@export var player: Node2D

var projectile: PackedScene = preload("res://Characters/spit_projectile.tscn")
var projectileSpeed: int = 100
var counter: int = 0
var health: int = 2

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var sprite_color: Color = $Sprite2D.modulate
@onready var damage_visual_timer: Timer = $DamageVisualTimer

# BUILT IN VIRTUAL METHODS

func _physics_process(_delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	#only have enemy chase player if within a certain distance
	if nav_agent.target_position.distance_to(position) > 700:
		velocity = Vector2(0,0)
	else:
		velocity = direction * moveSpeed
	sprite_2d.play("enemy-l")
	move_and_slide()

# MOVEMENT RELATED METHODS

# updates the target position of the navigation agent
func update_path() -> void:
	nav_agent.target_position = player.global_position
	
# on timer timeout the enemy updates the direction of its path toward the player
func _on_path_timer_timeout():
	update_path()
	
# COMBAT RELATED METHODS
	
# instantiates a projectile and initializes its speed and size
func inst(projectileVelocity: Vector2):
	var projectileInstance = projectile.instantiate()
	add_child(projectileInstance)
	projectileInstance.scale *= .4
	projectileInstance.velocity = projectileVelocity
	
# fires projectiles in a pattern specific to this enemy
func fire(speed):
	inst(Vector2(0, speed))
	inst(Vector2(0, -speed))
	inst(Vector2(speed, 0))
	inst(Vector2(-speed, 0))

# on timer timeout the enemy fires projectiles
func _on_fire_timer_timeout():
	fire(projectileSpeed)		

#HEALTH RELATED METHODS

func _on_damage_visual_timer_timeout():
	sprite_2d.modulate = sprite_color

func visualize_damage():
	sprite_2d.modulate = Color(1, 0, 0)
	damage_visual_timer.start()

# take damage
func get_damaged():
	visualize_damage()
	if health == 0:
		await damage_visual_timer.timeout
		queue_free()
	else:
		health -= 1
		
		
