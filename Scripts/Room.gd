extends Node

var room = preload("res://Scenes/room_variants.tscn")

var door_states = {
	Vector2(1,0): true,   # Right door
	Vector2(-1,0): true,  # Left door
	Vector2(0,1): true,   # Bottom door
	Vector2(0,-1): true   # Top door
  }

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
