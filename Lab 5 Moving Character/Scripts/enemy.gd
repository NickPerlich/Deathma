class_name Enemy
extends CharacterBody2D

enum FirePattern {
	STRAIGHT,
	SPIRAL,
}

@export var moveSpeed: int = 80
@export var player: Node2D
@export var fire_pattern: FirePattern = FirePattern.STRAIGHT

var straight_projectile: PackedScene = preload("res://Characters/spit_projectile.tscn")
var straight_projectile_speed: int = 100
var spiral_projectile: PackedScene = preload("res://Characters/spiral_spit_projectile.tscn")
var spiral_projectile_speed:int = 50
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
	
	if velocity.x > 0:
		sprite_2d.play("enemy-r")
	elif velocity.x < 0:
		sprite_2d.play("enemy-l")
	else:
		sprite_2d.play("enemy-d")

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
func straight_inst(projectile_velocity: Vector2):
	var projectile_instance = straight_projectile.instantiate()
	add_child(projectile_instance)
	projectile_instance.scale *= .4
	projectile_instance.velocity = projectile_velocity
	
# fires projectiles in a pattern specific to this enemy
func straight_fire(speed):
	straight_inst(Vector2(0, speed))
	straight_inst(Vector2(0, -speed))
	straight_inst(Vector2(speed, 0))
	straight_inst(Vector2(-speed, 0))

func spiral_fire(speed: int):
	var projectile_instance = spiral_projectile.instantiate()
	add_child(projectile_instance)
	projectile_instance.scale *= .4
	projectile_instance.speed = speed

# on timer timeout the enemy fires projectiles
func _on_fire_timer_timeout():
	if fire_pattern == FirePattern.STRAIGHT:
		straight_fire(straight_projectile_speed)
	else:
		spiral_fire(spiral_projectile_speed)		

#HEALTH RELATED METHODS

func _on_damage_visual_timer_timeout():
	sprite_2d.modulate = sprite_color

func visualize_damage():
	sprite_2d.modulate = Color(1, 0, 0)
	damage_visual_timer.start()

# take damage
func get_damaged(damage):
	visualize_damage()
	if health <= 0:
		await damage_visual_timer.timeout
		queue_free()
	else:
		print(health)
		health -= damage
		
		
