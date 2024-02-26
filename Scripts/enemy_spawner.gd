extends Node2D

@onready var room: room_instance

func _ready():
	room = get_parent() as room_instance
	room.room_activated_signal.connect(room_activated)
	
func room_activated():
	print('Enemy spawner active')
