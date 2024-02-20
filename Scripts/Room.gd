extends Node

var four_doors = preload("res://Scenes/room_4_doors.tscn").instantiate()
var basic_2_doors = preload("res://Scenes/room_2_doors.tscn").instantiate()

var variations = [
	four_doors,	
	basic_2_doors,
]

var chosen_variation = variations[randi() % variations.size()]

var room_instance = chosen_variation
var room = chosen_variation

var room_scene = preload("res://Scenes/room_variants.tscn")
var door_states = room.door_states

func set_door_state(direction, state):
	if direction in door_states:
		door_states[direction] = state

func is_door_enabled(direction):
	return door_states.get(direction, false)

var connected_rooms = {
	Vector2(1,0): null,
	Vector2(-1,0): null,
	Vector2(0,1): null,
	Vector2(0,-1): null,
}

var number_of_connections = 0
