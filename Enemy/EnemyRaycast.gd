extends RayCast2D
@onready var player: CharacterBody2D

func _ready():
	player = get_node("/root/Game/World/Player")
	

func _physics_process(delta):
	if(player):
		look_at(player.global_position)
