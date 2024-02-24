extends State
class_name EnemyShoot

@onready var target_node
@export var state_change_range: float = 40
@onready var enemy: CharacterBody2D = $"../.."
@onready var nav_agent: NavigationAgent2D = $"../../Navigation/NavigationAgent2D"
@onready var raycast: RayCast2D = $"../../RayCast2D"
@onready var bullet_manager = $"../../BulletManager"
@onready var timer: Timer = $"../../Navigation/Timer"


func Enter():	
	enemy.is_following = true
	var current_state = bullet_manager.get_node('StateMachine').current_state
	current_state.Transitioned.emit(current_state, 'basic')
	
func Exit():
	enemy.is_following = false
	var current_state = bullet_manager.get_node('StateMachine').current_state
	current_state.Transitioned.emit(current_state, 'stop')

func Physics_Update(delta: float):	
	if(enemy.player.global_position.distance_to(enemy.global_position) < 400):
		enemy.stop_moving()		
		enemy.is_following = false
	else:
		enemy.is_following = true
	if(enemy.player):
		bullet_manager.look_at(enemy.player.global_position)
		#Change state if raycast is within range on the player
		var raycast_colliding_node = raycast.get_collider();
	
		if raycast_colliding_node == null or raycast_colliding_node.name != 'VisibilityArea':
			Transitioned.emit(self, 'follow')

		
		if nav_agent.is_navigation_finished():
			return
		var axis = enemy.to_local(nav_agent.get_next_path_position()).normalized()
		var intended_velocity = axis * enemy.speed
		nav_agent.set_velocity(intended_velocity)
	
