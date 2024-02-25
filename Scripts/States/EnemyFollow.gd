extends State
class_name EnemyFollow


@export var state_change_range: float = 40
@onready var enemy: CharacterBody2D = $"../.."
@onready var nav_agent: NavigationAgent2D = $"../../Navigation/NavigationAgent2D"
@onready var raycast: RayCast2D = $"../../RayCast2D"
@onready var timer: Timer = $"../../Navigation/Timer"

func Enter():
	enemy.is_following = true
	
func Exit():
	enemy.is_following = false
	
func Physics_Update(delta: float):
	#Change state if raycast is within range on the player
	var raycast_colliding_node = raycast.get_collider();
	if raycast_colliding_node and raycast_colliding_node.name == 'VisibilityArea':
		Transitioned.emit(self, 'shoot')
		
	if nav_agent.is_navigation_finished():
		return
	var axis = enemy.to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * enemy.speed
	nav_agent.set_velocity(intended_velocity)
