extends Node

var four_doors = preload("res://Scenes/Rooms/Stage 1/Basic/room_4_doors.tscn").instantiate()
var basic_2_doors = preload("res://Scenes/Rooms/Stage 1/Basic/room_2_doors.tscn").instantiate()

var variations = [
	four_doors,	
	basic_2_doors,
]

var  start_room_1 = preload("res://Scenes/Rooms/Stage 1/Start/start_one.tscn").instantiate()
var  end_room_1 = preload("res://Scenes/Rooms/Stage 1/End/end_one.tscn").instantiate()

var start_variations = [
	start_room_1
]
var start_room = start_variations[randi() % start_variations.size()]

var end_variations = [
	end_room_1
]
var end_room = end_variations[randi() % end_variations.size()]

var chosen_variation = variations[randi() % variations.size()]

var room_instance = chosen_variation
var room = chosen_variation

var room_scene = preload("res://Scenes/room_variants.tscn")
var door_states = room.door_states
var type = 'basic' #basic | start | end | hidden

func set_door_state(direction, state):
	if direction in door_states:
		door_states[direction] = state

func is_door_enabled(direction, type):
	if type == 'basic':
		return chosen_variation.door_states.get(direction, false)
	elif type == 'start':
		return start_room.door_states.get(direction)
	elif type == 'end':
		return start_room.door_states.get(direction)
	elif type == 'hidden':
		return start_room.door_states.get(direction)

var connected_rooms = {
	Vector2(1,0): null,
	Vector2(-1,0): null,
	Vector2(0,1): null,
	Vector2(0,-1): null,
}

var number_of_connections = 0
