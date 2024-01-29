extends Node


var room_instance = preload("res://Scenes/room_variants.tscn").instantiate()
var room_index = randf_range(0, room_instance.get_child_count())
var room = room_instance.get_child(room_index)

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
