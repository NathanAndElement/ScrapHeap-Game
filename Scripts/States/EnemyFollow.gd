extends State
class_name EnemyFollow


@export var state_change_range: float = 40
@onready var enemy: CharacterBody2D = $"../.."
@onready var nav_agent: NavigationAgent2D = $"../../Navigation/NavigationAgent2D"
@onready var raycast: RayCast2D = $"../../RayCast2D"
@onready var player: CharacterBody2D = get_node("/root/Game/Testing/DungeonTester/MapNode/Player")

	
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
	
func recalc_path():
	if(enemy.player):
		nav_agent.target_position = enemy.player.global_position

func _on_timer_timeout():
	recalc_path()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	enemy.velocity = safe_velocity
	enemy.move_and_slide()
