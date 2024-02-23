extends RayCast2D
@onready var player: CharacterBody2D

func _ready():
	pass

func _physics_process(delta):
	if(!player):
		player = get_node("/root/Game/Testing/DungeonTester/MapNode/Player")
	if(player):
		look_at(player.global_position)
