extends State
class_name EnemyIdle

@onready var enemy: CharacterBody2D = $"../.."
@onready var nav_agent: NavigationAgent2D = $"../../Navigation/NavigationAgent2D"
@onready var player_detection_area = $"../../PlayerDetectionArea"
	
func Physics_Update(delta: float):
	pass


func _on_player_detection_area_body_entered(body):
	if body.name == 'Player':
		Transitioned.emit(self, 'follow')
