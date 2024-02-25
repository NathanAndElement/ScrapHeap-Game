extends CharacterBody2D

@export var speed = 37
@export var nav_agent: NavigationAgent2D
@export var health = 100
@export var damage = 20
@export var stop_radius = 100
@export var mag_size = 6
@export var reload_speed = 1
@onready var timer: Timer = $Navigation/Timer

var player: CharacterBody2D
var path = []
var map
var can_recalc = true
var is_following = false
var ramdom_direction = randf()

func _ready():
	z_index = 10
	player = get_node("/root/Game/Testing/DungeonTester/MapNode/Player")
	
func _physics_process(_delta):
	if(!player):
		player = get_node("/root/Game/Testing/DungeonTester/MapNode/Player")
	if health <= 0:
		kill_unit()
	
	if(is_following):
		if(player.global_position.distance_to(global_position) > 200 and can_recalc):
			can_recalc = false
			recalc_path()
		
		if nav_agent.is_navigation_finished():
			return
		var axis = to_local(nav_agent.get_next_path_position()).normalized()
		var intended_velocity = axis * speed
		nav_agent.set_velocity(intended_velocity)

func stop_moving():
	nav_agent.target_position = global_position
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * speed
	nav_agent.set_velocity(intended_velocity)

func _on_collision_area_entered(area):
	#Bullet damage
	if area.name == "BulletArea":
		var bullet = area.get_parent()
		health -= bullet.damage
		bullet.queue_free()
		
	#Damage player
	if area.name == "DamageArea":
		var player = area.get_parent()
		player.colliding_enemies.append(self)

func _on_collision_area_area_exited(area):
	if area.name == "DamageArea":
		var player = area.get_parent()
		player.colliding_enemies.remove_at(player.colliding_enemies.find(self))

	
func recalc_path():
	if(player and is_following):
		var centre = player.global_position
		var angle = ramdom_direction * PI * 2
		var x = centre.x + cos(angle) * stop_radius
		var y = centre.y + sin(angle) * stop_radius
		nav_agent.target_position = Vector2(x, y)

func _on_timer_timeout():
	if(is_following):
		var rand_time = randf() * 0.4 + 0.6
		timer.wait_time = rand_time
		can_recalc = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func kill_unit():
	queue_free()
