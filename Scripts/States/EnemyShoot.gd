extends State
class_name EnemyShoot

@onready var target_node
@export var state_change_range: float = 40
@onready var enemy: CharacterBody2D = $"../.."
@onready var nav_agent: NavigationAgent2D = $"../../Navigation/NavigationAgent2D"
@onready var raycast: RayCast2D = $"../../RayCast2D"
@onready var bullet_manager = $"../../BulletManager"

var player: CharacterBody2D

func Enter():	
	var current_state = bullet_manager.get_node('StateMachine').current_state
	current_state.Transitioned.emit(current_state, 'basic')
	

func Exit():
	var current_state = bullet_manager.get_node('StateMachine').current_state
	current_state.Transitioned.emit(current_state, 'stop')

func Physics_Update(delta: float):
	if(!player):
		player = get_node("/root/Game/Testing/DungeonTester/MapNode/Player")
		
	bullet_manager.look_at(player.global_position)
	#Change state if raycast is within range on the player
	var raycast_colliding_node = raycast.get_collider();
	
	if raycast_colliding_node == null or raycast_colliding_node.name != 'VisibilityArea':
		Transitioned.emit(self, 'follow')

		
	if nav_agent.is_navigation_finished():
		return
	var axis = enemy.to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * enemy.speed
	nav_agent.set_velocity(intended_velocity)
	

func recalc_path():
	if(target_node):
		nav_agent.target_position = target_node.global_position

func _on_timer_timeout():
	recalc_path()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	enemy.velocity = safe_velocity
	enemy.move_and_slide()
