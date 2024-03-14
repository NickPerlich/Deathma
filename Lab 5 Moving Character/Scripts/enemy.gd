extends CharacterBody2D

var projectile = preload("res://Characters/spit_projectile.tscn")
var projectileSpeed = 100
var counter = 0
@export var moveSpeed = 80
@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
var health = 2
	
# moves the enemy in a direction that is updated by the navigation agent
func _physics_process(_delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * moveSpeed
	move_and_slide()
	
# updates the target position of the navigation agent
func update_path() -> void:
	nav_agent.target_position = player.global_position

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
	
# on timer timeout the enemy updates the direction of its path toward the player
func _on_path_timer_timeout():
	update_path()

# on timer timeout the enemy fires projectiles
func _on_fire_timer_timeout():
	fire(projectileSpeed)		

func _on_area_2d_area_entered(area):
	if area.is_in_group("player_projectile"):
		if health == 0:
			queue_free()
		else:
			health -= 1
